from django.contrib.auth import get_user_model
from django.db.models import F, Avg, Q
from django.shortcuts import get_object_or_404

from rest_framework import (
    viewsets,
    views,
    permissions,
    response,
    status,
    generics,
    parsers,
    pagination
)
from rest_framework.authentication import TokenAuthentication
from geopy.distance import distance
from django_filters.rest_framework import DjangoFilterBackend

from restapp.serializers import *
from restapp.permissions import IsProfileOwner, IsAnonCreate, ObjectOwner
from users.models import (
    Company,
    Review,
    Album,
    Client,
    Category,
    Bookmarks,
    Notifications,
)
from .pagination import *

from promotion.models import CompanyPromotion


User = get_user_model()


class ClientsViews(viewsets.ModelViewSet):
    serializer_class = ClientsSerializer
    queryset = Client.objects.all()


class UsersViews(viewsets.ModelViewSet):
    serializer_class = UsersSerializer
    queryset = User.objects.filter(user_type=User.USER)
    lookup_field = 'phone'

    def perform_create(self, serializer):
        serializer.save()

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)

        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return response.Response({"status": "success", "message": ["Successful registered"]},
                                 status=status.HTTP_201_CREATED, headers=headers)


class CompaniesViews(generics.ListAPIView):
    serializer_class = CompaniesSerializer
    queryset = Company.objects.filter(status=Company.ACTIVE)
    filter_fields = ['category', ]
    search_fields = ['company_name', 'address', 'description', ]
    pagination_class = CompaniesPagination

    def get_queryset(self):
        if self.request.GET.get('rate'):
            rate = self.request.GET.get('rate', 0)
            self.queryset = self.queryset.annotate(total_rate=Avg('review__rate')).filter(Q(total_rate__lte=rate) | Q(total_rate=None))
        if self.request.GET.get('states'):
            now = datetime.now().time()
            states = self.request.GET.get('states').split(',')
            open_companies = closed_companies = unknown_companies = list()

            current_day_available_companies_queryset = WeekTime.objects.filter(day=current_week_day)

            if states.__contains__('open'):
                open_companies = current_day_available_companies_queryset.filter(opening_time__lte=now,
                                                                                 closing_time__gte=now).values_list('company', flat=True)
            if states.__contains__('closed'):
                open_companies_queryset = current_day_available_companies_queryset.filter(opening_time__lte=now, closing_time__gte=now).values_list('company', flat=True)
                closed_companies_queryset = current_day_available_companies_queryset.values_list('company', flat=True)
                closed_companies = list(set(closed_companies_queryset) - set(open_companies_queryset))

            if states.__contains__('unknown'):
                current_day_available_companies =  current_day_available_companies_queryset.distinct('company').values_list('company', flat=True)
                unknown_companies = self.queryset.exclude(pk__in=current_day_available_companies).values_list('id', flat=True)
            all_companies = list(open_companies) + list(closed_companies) + list(unknown_companies)
            self.queryset = self.queryset.filter(pk__in=all_companies)
        return self.queryset


class CompaniesPromotedViews(generics.ListAPIView):
    pagination_class = None
    serializer_class = CompaniesSerializer
    filter_fields = ['category', ]
    search_fields = ['company_name', 'address', 'description', ]
    promotions_query = CompanyPromotion.objects.filter(status=True,
                                                       counter__gt=0,
                                                       promotion_type__promote_type__contains='show_in_search',
                                                       )

    def get_queryset(self):
        promotions_list = self.promotions_query.values_list('company', flat=True)
        return Company.objects.filter(pk__in=promotions_list, status=Company.ACTIVE)

    def list(self, request, *args, **kwargs):

        self.promotions_query.filter(action_type='view').update(counter=F('counter')-1)
        return super().list(request, *args, **kwargs)


class CompaniesPromotedRelatedViews(generics.RetrieveAPIView):
    pagination_class = None
    serializer_class = CompaniesSerializer
    filter_fields = ['category']
    promotions_query = CompanyPromotion.objects.filter(status=True,
                                                       counter__gt=0,
                                                       promotion_type__promote_type__contains='show_in_related',
                                                       ).order_by('?')
    promotions_list = None

    def get_object(self):
        if self.request.GET.get('category'):
            category = self.request.GET.get('category')
            self.promotions_list = self.promotions_query.filter(company__category=category).first()
        else:
            self.promotions_list = self.promotions_query.first()
        if self.promotions_list:
            return Company.objects.filter(pk=self.promotions_list.company.id, status=Company.ACTIVE).order_by('?').first()
        else:
            return Company.objects.none()

    def retrieve(self, request, *args, **kwargs):
        if self.get_object():
            if self.promotions_list.action_type == 'view':
                self.promotions_list.counter = self.promotions_list.counter - 1
                self.promotions_list.save()
        return super().retrieve(request, *args, **kwargs)


class CompaniesNearByViews(generics.ListAPIView):
    serializer_class = CompaniesNearBySerializer
    queryset = Company.objects.filter(status=Company.ACTIVE)
    filter_fields = ['category', ]
    search_fields = ['company_name', 'address', 'description', ]

    def get_queryset(self):

        distance = self.request.GET.get('distance')
        latitude = self.request.GET.get('latitude')
        longitude = self.request.GET.get('longitude')

        if distance and latitude and longitude:
            kwargs = dict()
            if self.request.GET.get('rate'):
                rate = self.request.GET.get('rate', 0)
                kwargs.update({'rate': rate})

            if self.request.GET.get('states'):
                kwargs.update({'states': self.request.GET.get('states')})

            queryset = Company.objects.get_nearby_locations(distance=float(distance),
                                                            location_lat_long=(float(latitude), float(longitude)), **kwargs)
        else:
            queryset = []
        return queryset


class CompaniesPromotedNearByViews(generics.ListAPIView):
    serializer_class = CompaniesNearBySerializer
    queryset = Company.objects.filter(status=Company.ACTIVE)
    filter_fields = ['category', ]
    search_fields = ['company_name', 'address', 'description', ]

    def get_queryset(self):

        distance = self.request.GET.get('distance')
        latitude = self.request.GET.get('latitude')
        longitude = self.request.GET.get('longitude')

        if distance and latitude and longitude:
            kwargs = dict()
            if self.request.GET.get('rate'):
                rate = self.request.GET.get('rate', 0)
                kwargs.update({'rate': rate})

            if self.request.GET.get('states'):
                kwargs.update({'states': self.request.GET.get('states')})

            queryset = Company.objects.get_nearby_locations(distance=float(distance),
                                                            location_lat_long=(float(latitude), float(longitude)), **kwargs)
        else:
            queryset = []
        return queryset


class CompaniesNearByForUserViews(generics.ListAPIView):
    serializer_class = CompaniesForUserSerializer
    queryset = Company.objects.filter(status=Company.ACTIVE)
    filter_fields = ['category', ]
    search_fields = ['company_name', 'address', 'description', ]

    def get_queryset(self):

        distance = self.request.GET.get('distance')
        latitude = self.request.GET.get('latitude')
        longitude = self.request.GET.get('longitude')

        if distance and latitude and longitude:
            kwargs = dict()
            if self.request.GET.get('rate'):
                rate = self.request.GET.get('rate', 0)
                kwargs.update({'rate': rate})

            if self.request.GET.get('states'):
                kwargs.update({'states': self.request.GET.get('states')})

            queryset = Company.objects.get_nearby_locations(distance=float(distance),
                                                            location_lat_long=(float(latitude), float(longitude)), **kwargs)
        else:
            queryset = []
        return queryset


class CompanyDetailViews(generics.RetrieveAPIView):
    serializer_class = CompaniesSerializer

    def get_object(self):
        pk = self.kwargs.get('company_id')
        return get_object_or_404(Company, pk=pk)

    def get(self, request, *args, **kwargs):
        if request.GET.get('promoted'):
            company_id = self.kwargs.get('company_id')
            promote_type = request.GET.get('promoted')

            promotion = CompanyPromotion.objects.filter(company_id=company_id, action_type='click',
                                                        promotion_type__promote_type=promote_type)
            if promotion.exists():
                promotion.update(counter=F('counter')-1)
        return super().get(request, *args, **kwargs)


class CompanyDetailForUserViews(generics.RetrieveAPIView):
    serializer_class = CompaniesForUserSerializer

    def get_object(self):
        pk = self.kwargs.get('company_id')
        return get_object_or_404(Company, pk=pk)

    def get(self, request, *args, **kwargs):
        if request.GET.get('promoted'):
            company_id = self.kwargs.get('company_id')
            promote_type = request.GET.get('promoted')

            promotion = CompanyPromotion.objects.filter(company_id=company_id, action_type='click',
                                                        promotion_type__promote_type=promote_type)
            if promotion.exists():
                promotion.update(counter=F('counter')-1)
        return super().get(request, *args, **kwargs)


class CompanyFilesViews(generics.ListAPIView):
    serializer_class = CompanyFilesSerializer

    def get_queryset(self):
        company = Company.objects.get(pk=self.kwargs.get('company_id'))
        files = File.objects.filter(album__company=company, album__owner=company.user).order_by('-pk')
        return files


class CompanyReviewViews(generics.ListAPIView):
    serializer_class = ReviewSerializer
    queryset = Review.objects.filter(parent=None)
    pagination_class = CompanyReviewsPagination

    def get_queryset(self):
        reviews = self.queryset.filter(company=self.kwargs.get('company_id')).order_by('-pk')
        return reviews


class CompanyReviewForUserViews(generics.ListAPIView):
    serializer_class = ReviewSerializerForUser
    queryset = Review.objects.filter(parent=None)

    def get_queryset(self):
        reviews = self.queryset.filter(company=self.kwargs.get('company_id')).order_by('-pk')
        return reviews


class CompanyReviewCreateViews(generics.CreateAPIView,):
    serializer_class = ReviewCreateSerializer


class CompanyReviewRUD(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ReviewReadUpdateDestroySerializer
    lookup_url_kwarg = ['review_id']

    def get_object(self):
        review = Review.objects.get(pk=self.kwargs.get('review_id'))
        if not review.album:
            review.album = Album.objects.create(**{
                'owner': review.author,
                'company': review.company
            })
        return review


class ReviewsViews(viewsets.ModelViewSet):
    serializer_class = ReviewSerializer
    queryset = Review.objects.all()
    filter_backends = (DjangoFilterBackend,)


class ReviewAllFilesView(generics.ListAPIView):
    serializer_class = ReviewFileUploadSerializer
    queryset = File.objects.all()

    def get_queryset(self):
        company = Company.objects.get(pk=self.kwargs.get('company_id'))
        return self.queryset.filter(album__company=company).exclude(album__owner=company.user).order_by('-pk')


class ReviewFilesView(generics.ListAPIView):
    serializer_class = ReviewFileUploadSerializer
    queryset = File.objects.all()

    def get_queryset(self):
        review = Review.objects.get(pk=self.kwargs.get('review_id'))
        return self.queryset.filter(album=review.album).order_by('-pk')


class ReviewFilesUploadView(generics.CreateAPIView):
    serializer_class = ReviewFileUploadSerializer


class CategoryViews(generics.ListAPIView):
    serializer_class = CategorySerializer
    queryset = Category.objects.filter(parent=None)


class CategoryTopViews(generics.ListAPIView):
    serializer_class = CategoryTopSerializer
    queryset = Category.objects.filter(is_top=1)


class BookmarkViews(generics.ListAPIView):
    serializer_class = BookmarkListSerializer

    def get_queryset(self):
        phone = self.kwargs.get('phone')
        user = get_object_or_404(User, phone=phone)
        return Bookmarks.objects.filter(user=user).order_by('-pk')


class BookmarkCreateViews(generics.CreateAPIView):
    serializer_class = BookmarkSerializer

    def create(self, request, *args, **kwargs):
        user_instance = User.objects.get(phone=kwargs.get('phone'))

        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)
        company = Company.objects.get(id=request.data.get('company'))
        bookmarks = Bookmarks.objects.filter(company=company, user=user_instance)
        if bookmarks.exists():
            msg = "Bookmark already exists"
            response_status = status.HTTP_200_OK
        else:
            Bookmarks.objects.create(**{
                'company': company,
                'user': user_instance
            })
            msg = "Bookmark successfully added"
            response_status = status.HTTP_201_CREATED
        headers = self.get_success_headers(serializer.data)
        return response.Response({"status": "success", "message": [msg]}, status=response_status, headers=headers)


class BookmarkDestroyViews(generics.DestroyAPIView):
    serializer_class = BookmarkSerializer
    authentication_classes = [TokenAuthentication, ]
    model = Bookmarks

    def get_object(self):
        company_id = self.kwargs.get('company_id')
        phone = self.kwargs.get('phone')
        user_instance = User.objects.get(phone=phone)
        return self.model.objects.get(company_id=company_id, user=user_instance)


class ClientListView(generics.ListAPIView):
    serializer_class = ClientSerializer
    queryset = Client.objects.all()


class ClientReviewListView(generics.ListAPIView):
    serializer_class = ReviewSerializer
    queryset = Review.objects.all()

    def get_queryset(self):
        return self.queryset.filter(author__phone=self.kwargs.get('phone')).order_by('-pk')


class ClientRetrieveView(generics.RetrieveAPIView):
    serializer_class = ClientSerializer
    model = Client

    def get_object(self):
        return get_object_or_404(Client, user__phone=self.kwargs.get('phone'))


class ClientNotificationsView(generics.ListAPIView):
    model = Notifications
    serializer_class = NotificationsSerializer

    def get_queryset(self):
        phone = self.kwargs.get('phone')
        return self.model.objects.filter(user__phone=phone).order_by('-pk')


class ClientNotificationsClearView(generics.DestroyAPIView):
    model = Notifications
    serializer_class = NotificationsSerializer
    lookup_url_kwarg = ['phone']

    def get_queryset(self):
        phone = self.kwargs.get('phone')
        return self.model.objects.filter(user__phone=phone).order_by('-pk')

    def destroy(self, request, *args, **kwargs):
        query_set = self.get_queryset()
        query_set.delete()
        return response.Response(status.HTTP_204_NO_CONTENT)


class ClientNotificationsUpdateView(generics.UpdateAPIView):
    model = Notifications
    serializer_class = NotificationsSerializer
    lookup_url_kwarg = ['notification_id']

    def get_object(self):
        return get_object_or_404(self.model, pk=self.kwargs.get('notification_id'))

    def update(self, request, *args, **kwargs):
        instance = super().update(request, *args, **kwargs)
        return response.Response({"status": "success", "message": ["Successful updated"]})


class ClientRecentlyViewedListView(generics.ListAPIView):
    serializer_class = CompaniesSerializer
    model = RecentlyViewed

    def get_queryset(self):
        viewed_companies = self.model.objects.filter(user__phone=self.kwargs.get('phone')).values_list('company')
        return Company.objects.filter(pk__in=viewed_companies)


class ClientRecentlyViewedCreateView(generics.CreateAPIView):
    serializer_class = RecentlyViewedSerializer
    model = RecentlyViewed

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)
        phone = kwargs.get('phone')
        company_id = request.data.get('company')

        viewed_company = self.model.objects.filter(user__phone=phone, company__id=company_id)
        if not viewed_company.exists():
            self.model.objects.create(**{
                'user': User.objects.get(phone=phone),
                'company': Company.objects.get(id=company_id)
            })
        headers = self.get_success_headers(serializer.data)
        return response.Response({"status": "success", "message": ["Successful added"]},
                                 status=status.HTTP_201_CREATED, headers=headers)


class ClientRecentlyViewedDeleteView(generics.DestroyAPIView):
    serializer_class = RecentlyViewedSerializer
    authentication_classes = [TokenAuthentication]
    model = RecentlyViewed

    def get_object(self):
        return self.model.objects.get(company_id=self.kwargs.get('company_id'), user__phone=self.kwargs.get('phone'))


class ClientRecentlyViewedClearAllView(generics.DestroyAPIView):
    serializer_class = RecentlyViewedSerializer
    authentication_classes = [TokenAuthentication]
    model = RecentlyViewed
    lookup_url_kwarg = ['phone']

    def get_queryset(self):
        phone = self.kwargs.get('phone')
        return self.model.objects.filter(user__phone=phone)

    def destroy(self, request, *args, **kwargs):
        query_set = self.get_queryset()
        query_set.delete()
        return response.Response(status.HTTP_204_NO_CONTENT)


class ClientCreateView(generics.CreateAPIView):
    serializer_class = ClientCreateSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)

        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return response.Response({"status": "success", "message": ["Successful added"]},
                                 status=status.HTTP_201_CREATED, headers=headers)


class ClientUpdateView(generics.UpdateAPIView):
    serializer_class = ClientUpdateSerializer

    def get_object(self):
        return Client.objects.get(user__phone=self.kwargs.get('phone'))

    def update(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)
        user_instance = User.objects.get(phone=kwargs.get('phone'))
        if serializer.data.get('first_name'):
            user_instance.first_name = serializer.data.get('first_name')
        if serializer.data.get('last_name'):
            user_instance.last_name = serializer.data.get('last_name')
        user_instance.save()

        client_instance = self.get_object()
        client_instance.user = user_instance

        if serializer.data.get('date_of_birthday'):
            client_instance.date_of_birthday = serializer.data.get('date_of_birthday')

        if serializer.data.get('gender'):
            client_instance.gender = serializer.data.get('gender')

        client_instance.save()
        return response.Response({"status": "success", "message": ["Successful updated"]})


class ClientPasswordChangeView(generics.GenericAPIView):
    serializer_class = ClientPasswordSerializer
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)

    def get_object(self):
        user_instance = self.get_queryset().get(phone=self.kwargs.get('phone'))
        return user_instance

    def post(self, request, *args, **kwargs):
        user_instance = self.get_object()
        serializer = self.get_serializer(user_instance, data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            message = {
                'status': 'success',
                'message': [
                    'Password successful changed'
                ]
            }
            return response.Response(message)
        else:
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)


class ClientAvatarUploadView(generics.CreateAPIView):
    serializer_class = ClientAvatarSerializer

    def create(self, request, *args, **kwargs):
        user_instance = User.objects.get(phone=kwargs.get('phone'))
        request.data['user'] = user_instance.id
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            errors = []
            for error in serializer.errors:
                errors.append(serializer.errors.get(error)[0])
            return response.Response({"status": "fail", "message": errors},
                                     status=status.HTTP_400_BAD_REQUEST)

        image = request.FILES['image']
        user = user_instance.id
        user_images = UserAvatars.objects.filter(user_id=user)
        if user_images.exists():
            for user_image in user_images:
                user_image.image = image
                user_image.save()
            msg = "Image successful updated"
            response_status = status.HTTP_200_OK
        else:
            UserAvatars.objects.create(**{
                'image': image,
                'user': user_instance
            })
            msg = "Image successful uploaded"
            response_status = status.HTTP_201_CREATED
        return response.Response({"status": "success", "message": [msg]}, status=response_status)


class ReviewLikeDislikeView(generics.CreateAPIView):
    serializer_class = ReviewLikeDislikeSerializer


class ReviewLikeDislikeAllView(generics.ListAPIView):
    serializer_class = ReviewLikeDislikeSerializer
    queryset = ReviewLikeDislike.objects.all()

    def get_queryset(self):
        review = Review.objects.get(pk=self.kwargs.get('review_id'))
        return self.queryset.filter(review=review).order_by('-pk')

