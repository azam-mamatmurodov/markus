from datetime import date, datetime
import calendar

from django.contrib.auth import get_user_model
from django.conf import settings
from django.db.models import F

from rest_framework import serializers, mixins
from rest_framework_recursive.fields import RecursiveField
from geosimple.fields import convert_to_point
from geosimple.utils import Point as GeoPoint
from pyfcm import FCMNotification


from users.models import *
from promotion.models import CompanyPromotion, PROMOTE_TYPES
from restapp.validators import validate_phone_number

User = get_user_model()
push_service = FCMNotification(api_key=settings.FCM_APIKEY)

current_day = date.today().weekday()
current_week_day = get_week_day(current_day)


def send_push_for_topic(phone, message, **kwargs):
    receiver = User.objects.get(phone=phone)
    if kwargs.get('notification_sender'):
        notification_sender = User.objects.get(id=kwargs.get('notification_sender'))
    else:
        notification_sender = None
    Notifications.objects.create(**{
        'title': kwargs.get('title', message),
        'user': receiver,
        'notification_sender': notification_sender,
        'text': message,
    })
    return push_service.notify_topic_subscribers(topic_name=phone, message_body=message, sound="Default", tag='true')


class RecursiveSerializer(serializers.Serializer):
    def to_representation(self, value):
        serializer = self.parent.parent.__class__(value, context=self.context)
        return serializer.data


class ClientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Client
        fields = [
            'date_of_birthday',
            'gender',
            'user',
        ]


class UsersSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    gender = serializers.CharField(source='client.gender', required=False,)
    date_of_birthday = serializers.DateField(source='client.date_of_birthday', required=False, allow_null=True)

    class Meta:
        model = User
        fields = ('id',  'phone', 'first_name', 'last_name', 'is_active',
                  'password', 'gender', 'date_of_birthday', )
        write_only_fields = ('password', )
        read_only_fields = ('is_staff', 'is_active', 'date_joined', )

    def create(self, validated_data):
        client = validated_data.pop('client', None)

        user_instance = super(UsersSerializer, self).create(validated_data)
        user_instance.set_password(validated_data['password'])

        try:
            user_instance.client
        except Client.DoesNotExist:
            if client:
                client.update({'user': user_instance})
                client_instance = Client.objects.create(**client)
                client_instance.save()
        if client:
            user_instance.client.gender = client.get('gender', None)
            user_instance.client.date_of_birthday = client.get('date_of_birthday', None)
            user_instance.client.save()

        user_instance.save()
        return user_instance

    def update(self, instance, validated_data):
        client = validated_data.pop('client', None)
        validated_data.pop('password', None)

        instance_update = super().update(instance, validated_data)

        try:
            instance.client
        except Client.DoesNotExist:
            if client:
                client.update({'user': instance})
                client_instance = Client.objects.create(**client)
                client_instance.save()
        if client:
            instance_update.client.gender = client.get('gender', None)
            instance_update.client.date_of_birthday = client.get('date_of_birthday', None)
            instance_update.client.save()
        instance_update.save()
        return instance_update


class CompaniesSerializer(serializers.ModelSerializer):
    company_id = serializers.IntegerField(source='id')
    category = serializers.SerializerMethodField()
    description = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()
    total_rate = serializers.SerializerMethodField()
    location = serializers.SerializerMethodField()
    opening_time = serializers.SerializerMethodField()
    closing_time = serializers.SerializerMethodField()
    company_reviews = serializers.SerializerMethodField()
    email = serializers.EmailField(source='user.email')

    class Meta:
        model = Company
        extra_fields = ['avatar', ]
        exclude = ['user', 'id', ]

    @staticmethod
    def get_company_reviews(obj):
        return obj.review_set.all().count()

    @staticmethod
    def get_category(obj):
        return [{
            'name': obj.category.name,
            'id': obj.category.id
        }]

    @staticmethod
    def get_description(obj):
        return obj.description

    def get_avatar(self, obj):
        try:
            file = obj.user.get_avatar(self.context['request'])
        except (ValueError, AttributeError):
            return None

        return file

    @staticmethod
    def get_total_rate(obj):
        return obj.get_total_rate

    @staticmethod
    def get_location(obj):
        try:
            location_hash_convert = convert_to_point(obj.location)
        except:
            return None
        return str(location_hash_convert.latitude) + "," + str(location_hash_convert.longitude)

    @staticmethod
    def get_opening_time(obj):
        if current_week_day:
            week_time_for_company = WeekTime.objects.filter(company=obj)
            week_time_instance = week_time_for_company.filter(day=current_week_day).values('opening_time')
            if week_time_instance.exists():
                return week_time_instance.first().get('opening_time')
            else:
                return None
        return None

    @staticmethod
    def get_closing_time(obj):
        if current_week_day:
            week_time_for_company = WeekTime.objects.filter(company=obj)
            week_time_instance = week_time_for_company.filter(day=current_week_day).values('closing_time')
            if week_time_instance.exists():
                return week_time_instance.first().get('closing_time')
            else:
                return None
        return None


class CompaniesNearBySerializer(CompaniesSerializer):
    distance = serializers.SerializerMethodField()
    is_promoted = serializers.SerializerMethodField()
    email = serializers.EmailField(source='user.email')

    class Meta:
        model = CompaniesSerializer.Meta.model
        extra_fields = CompaniesSerializer.Meta.extra_fields + ['distance', 'is_promoted', ]
        exclude = ['user', 'id', ]

    def get_distance(self, obj):
        latitude = self.context['view'].request.GET.get('latitude')
        longitude = self.context['view'].request.GET.get('longitude')

        point = GeoPoint(latitude=latitude, longitude=longitude)
        obj_location = GeoPoint(obj.location.latitude, obj.location.longitude)
        distance_in_km = point.distance_from(obj_location)
        return distance_in_km.km

    @staticmethod
    def get_is_promoted(obj):
        promoted = False
        promotion = CompanyPromotion.objects.filter(company_id=obj.id,
                                                    promotion_type__promote_type__contains='show_in_search',
                                                    counter__gt=0, status=True)
        if promotion.exists():
            promotion.filter(action_type='view').update(counter=F('counter')-1)
            promoted = True
        return promoted


class NotificationsSerializer(serializers.ModelSerializer):
    company = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta:
        model = Notifications
        fields = ['title', 'text', 'company', 'image', 'id', 'is_read', ]
        read_only_fields = ['title', 'text', ]

    @staticmethod
    def get_company(obj):
        company = Company.objects.filter(user=obj.notification_sender, status=Company.ACTIVE)
        if company.exists():
            return company.first().id
        return None

    @staticmethod
    def get_image(obj):
        if obj.image:
            return obj.image.url
        return None


class CompaniesForUserSerializer(CompaniesSerializer):
    is_bookmarked = serializers.SerializerMethodField()

    class Meta:
        model = Company
        extra_fields = ['avatar', 'is_bookmarked', ]
        exclude = ['user', 'id', ]

    def get_is_bookmarked(self, obj):
        phone = self.context['view'].kwargs.get('phone')
        company_in_bookmark = Bookmarks.objects.filter(user__phone=phone, company_id=obj.id)
        if company_in_bookmark.exists():
            return True
        return False


class ReviewSerializer(serializers.ModelSerializer):
    review_id = serializers.IntegerField(source='id')
    author_id = serializers.IntegerField(source='author.id')
    parent_review_id = serializers.SerializerMethodField('get_parent')
    company_id = serializers.IntegerField(source='company.id')
    children = serializers.ListField(read_only=True, source='get_children', child=RecursiveField())
    created_at = serializers.SerializerMethodField()
    likes = serializers.SerializerMethodField()
    dislikes = serializers.SerializerMethodField()
    author_avatar = serializers.SerializerMethodField()
    author_fullname = serializers.SerializerMethodField()

    class Meta:
        model = Review
        fields = ['review_id', 'created_at', 'rate', 'comment', 'parent_review_id',
                  'author_id', 'album', 'company_id', 'children', 'likes', 'dislikes',
                  'author_fullname',
                  'author_avatar',
                  ]

    @staticmethod
    def get_parent(obj):
        if obj.parent is not None:
            return obj.parent.id
        else:
            return None

    @staticmethod
    def get_created_at(obj):
        return obj.created_at.timestamp()

    @staticmethod
    def get_likes(obj):
        return ReviewLikeDislike.objects.filter(review=obj, rate=1).count()

    @staticmethod
    def get_dislikes(obj):
        return ReviewLikeDislike.objects.filter(review=obj, rate=-1).count()

    def get_author_avatar(self, obj):
        return obj.author.get_avatar(self.context['request'])

    @staticmethod
    def get_author_fullname(obj):
        return obj.author.get_full_name()


class ReviewSerializerForUser(ReviewSerializer):
    rated_status = serializers.SerializerMethodField()

    class Meta:
        model = Review
        fields = ReviewSerializer.Meta.fields + ['rated_status']

    def get_rated_status(self, obj):
        phone = self.context['view'].kwargs.get('phone')

        review_rated = ReviewLikeDislike.objects.filter(like_dislike_user__phone=phone, review=obj)
        if review_rated.exists():
            return review_rated.first().rate
        return 0


class ReviewCreateSerializer(serializers.ModelSerializer):
    author_phone = serializers.CharField(source='author.phone')
    created_at = serializers.SerializerMethodField()

    class Meta:
        model = Review
        exclude = ['company', 'lft', 'rght', 'tree_id', 'level', 'author', ]

    def create(self, validated_data):
        company_id = self.context.get('view').kwargs.get('company_id')
        author_phone = validated_data.get('author').get('phone')
        company = Company.objects.get(pk=company_id)
        author = User.objects.get(phone=author_phone)
        album = Album.objects.create(**{
            'owner': author,
            'company': company
        })
        validated_data['author'] = author
        validated_data['company'] = company
        validated_data['album'] = album

        instance = super().create(validated_data)

        if instance.parent:
            parent_author = instance.parent.author

            phone = parent_author.phone
            message = "To your review has been replied"
            kwargs = dict()
            kwargs['title'] = "Replied to review"
            kwargs['notification_sender'] = author.id
            result = send_push_for_topic(phone, message, **kwargs)
            if result:
                print('Successfully sent')
        else:
            Notifications.objects.create(**{
                'title': 'Added new review',
                'user': company.user,
                'notification_sender': author,
                'text': 'You have new review from {}'.format(author.get_full_name()),
            })
        return instance

    @staticmethod
    def get_created_at(obj):
        return obj.created_at.timestamp()


class ReviewReadUpdateDestroySerializer(serializers.ModelSerializer):
    created_at = serializers.SerializerMethodField()

    class Meta:
        model = Review
        fields = ['created_at', 'comment', 'author', 'parent', 'album', ]

    @staticmethod
    def get_created_at(obj):
        return obj.created_at.timestamp()


class ReviewLikeDislikeSerializer(serializers.ModelSerializer):
    phone = serializers.CharField(source='like_dislike_user.phone')

    class Meta:
        model = ReviewLikeDislike
        exclude = ['like_dislike_user', 'review']

    def create(self, validated_data):
        phone = validated_data.get('like_dislike_user').get('phone')
        review_id = self.context['view'].kwargs.get('review_id')
        like_dislike_user = User.objects.get(phone=phone)
        review = Review.objects.get(pk=review_id)

        if self.Meta.model.objects.filter(like_dislike_user=like_dislike_user, review=review).exists():
            instance = self.Meta.model.objects.get(like_dislike_user=like_dislike_user, review=review)
            instance.rate = validated_data.get('rate')
            instance.save()
        else:
            validated_data['like_dislike_user'] = like_dislike_user
            validated_data['review'] = review
            instance = super().create(validated_data)

        if review.author:
            review_author = review.author
            if validated_data.get('rate') == 1:
                rated_as = 'like'
            elif validated_data.get('rate') == -1:
                rated_as = 'dislike'
            else:
                rated_as = 'neutral'
            message = "Hi, Your review was rated as " + rated_as

            kwargs = dict()
            kwargs['title'] = "Review was rated"
            kwargs['notification_sender'] = like_dislike_user.id

            result = send_push_for_topic(review_author.phone, message, **kwargs)
            if result:
                print('Successfully sent')
        return instance


class CategorySerializer(serializers.ModelSerializer):
    children = serializers.ListField(read_only=True, source='get_children', child=RecursiveField())

    class Meta:
        model = Category
        fields = ['id', 'name', 'is_top', 'icon', 'parent', 'children', 'svg_icon', ]


class CategoryTopSerializer(serializers.ModelSerializer):

    class Meta:
        model = Category
        fields = ['id', 'name', 'is_top', 'icon', 'parent', 'svg_icon', ]


class BookmarkListSerializer(serializers.ModelSerializer):
    bookmark_id = serializers.IntegerField(source='id')
    company = CompaniesSerializer(read_only=True)
    company_reviews = serializers.SerializerMethodField()

    class Meta:
        model = Bookmarks
        fields = ['bookmark_id', 'company', 'company_reviews', ]

    def get_company_reviews(self, obj):
        return obj.company.review_set.all().count()


class BookmarkSerializer(serializers.ModelSerializer):

    class Meta:
        model = Bookmarks
        fields = [
            'company',
        ]


class ClientSerializer(serializers.ModelSerializer):
    phone = serializers.CharField(source='user.phone')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    avatar = serializers.SerializerMethodField()

    class Meta:
        model = Client
        fields = [
            'phone',
            'first_name',
            'last_name',
            'date_of_birthday',
            'gender',
            'avatar',
        ]

    def get_avatar(self, obj):
        return obj.user.get_avatar(self.context['request'])


class ClientCreateSerializer(serializers.ModelSerializer):
    phone = serializers.CharField(source='user.phone')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    password = serializers.CharField(source='user.password')

    class Meta:
        model = Client
        fields = [
            'phone',
            'first_name',
            'last_name',
            'date_of_birthday',
            'gender',
            'password'
        ]

    def validate_phone(self, value):
        phone = value
        if not validate_phone_number(phone):
            raise serializers.ValidationError('Invalid phone number')

        try:
            User.objects.get(phone=phone)
            raise serializers.ValidationError('Already exist account')
        except User.DoesNotExist:
            pass
        return phone

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        phone = user_data.get('phone')
        first_name = user_data.get('first_name')
        last_name = user_data.get('last_name')
        password = user_data.get('password')

        user_instance = User.objects.create(**{
            'phone': phone,
            'first_name': first_name,
            'last_name': last_name
        })
        user_instance.is_active = True
        user_instance.set_password(password)
        user_instance.save()
        kwargs = {}
        if 'date_of_birthday' in validated_data:
            kwargs.update({
                'date_of_birthday': validated_data.get('date_of_birthday')
            })
        if 'gender' in validated_data:
            kwargs.update({
                'gender': validated_data.get('gender')
            })
        kwargs.update({
            'user': user_instance
        })
        client_instance = Client.objects.create(**kwargs)
        return client_instance


class ClientUpdateSerializer(serializers.ModelSerializer):
    first_name = serializers.CharField(required=False, allow_null=True)
    last_name = serializers.CharField(required=False, allow_null=True)

    class Meta:
        model = Client
        fields = [
            'first_name',
            'last_name',
            'date_of_birthday',
            'gender'
        ]


class ClientPasswordSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=True, write_only=True)

    class Meta:
        model = User
        fields = (
            'password',
        )

    def update(self, instance, validated_data):
        user = instance
        user.set_password(validated_data.get('password'))
        user.save()
        return user


class ClientAvatarSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserAvatars
        fields = [
            'image',
            'user'
        ]


class ReviewFileUploadSerializer(serializers.ModelSerializer):

    class Meta:
        model = File
        fields = ['file']

    def create(self, validated_data):
        kwargs = self.context['view'].kwargs
        review_id = kwargs.get('review_id')
        review = Review.objects.get(id=review_id)
        if not review.album:
            album = Album.objects.create(**{
                'owner': review.author,
                'company': review.company
            })
            review.album = album
            review.save()
        file_instance = self.Meta.model.objects.create(**{
            'file': validated_data.get('file'),
            'album': review.album
        })
        return file_instance


class CompanyFilesSerializer(serializers.ModelSerializer):
    class Meta:
        model = File
        fields = ['file']


class RecentlyViewedSerializer(serializers.ModelSerializer):

    class Meta:
        model = RecentlyViewed
        fields = ['company', ]


class RecentlyViewedListSerializer(serializers.ModelSerializer):
    company = CompaniesSerializer(read_only=True)

    class Meta:
        model = RecentlyViewed
        fields = ['company', ]

