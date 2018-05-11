from django import forms
from django.contrib.auth import get_user_model, update_session_auth_hash, authenticate
from django.utils.translation import ugettext as _
from django.forms.models import inlineformset_factory

from users.models import Category, Company, File, Album, Review, UserAvatars, Notifications
from .svgimagefield import SVGAndImageFormField


User = get_user_model()


class LoginForm(forms.Form):
    username = forms.CharField(max_length=60)
    passwd = forms.CharField(widget=forms.PasswordInput(), max_length=60)

    def clean(self):
        clean_data = super().clean()
        return clean_data


class RegisterForm(forms.ModelForm):
    username = forms.CharField(max_length=60)
    email = forms.CharField(max_length=60, widget=forms.EmailInput(), required=False)
    first_name = forms.CharField(max_length=60)
    last_name = forms.CharField(max_length=60)
    passwd = forms.CharField(widget=forms.PasswordInput())
    confirm_passwd = forms.CharField(widget=forms.PasswordInput())

    class Meta:
        model = Company
        fields = ['company_name', 'category', 'address', ]

    def clean(self):
        cleaned_data = super().clean()
        try:
            user = User.objects.get(phone=cleaned_data.get('username'))
            self.add_error('username', _('User already exist with this phone {}'.format(cleaned_data.get('username'))))
        except User.DoesNotExist:
            pass

        if cleaned_data.get('passwd') != cleaned_data.get('confirm_passwd'):
            self.add_error('passwd', _('Passwords not match'))

        return cleaned_data

    def save(self, commit=True):
        instance = super().save(commit=False)

        username = self.cleaned_data.get('username')
        passwd = self.cleaned_data.get('passwd')
        first_name = self.cleaned_data.get('first_name')
        last_name = self.cleaned_data.get('last_name')
        email = self.cleaned_data.get('email')

        if commit:
            user_instance = User.objects.create_user(phone=username, password=passwd, username=username)
            instance.user = user_instance
            instance.user.user_type = User.COMPANY
            if first_name:
                instance.user.first_name = first_name
            if last_name:
                instance.user.last_name = last_name
            if email:
                instance.user.email = email
            instance.user.save()
        instance.status = Company.ACTIVE
        instance.location = {'latitude': 41.2994958, 'longitude': 69.24007340000003}
        instance.save()
        return instance


class ProfileUpdateForm(forms.ModelForm):
    avatar = forms.ImageField(required=False)
    passwd = forms.CharField(widget=forms.PasswordInput(attrs={'autocomplete': 'nope'}), required=False)
    email = forms.EmailField(max_length=60)

    profile = None

    def __init__(self, *args, **kwargs):
        self.profile = kwargs.get('instance')
        super(ProfileUpdateForm, self).__init__(*args, **kwargs)

    class Meta:
        model = Company
        fields = '__all__'
        exclude = ['status', 'user', '']

    def clean(self):
        cleaned_data = super().clean()
        if self.profile.user.phone != cleaned_data.get('username'):
            try:
                user = User.objects.get(phone=cleaned_data.get('username'))
                self.add_error('username', _('User already exist with this phone {}'.format(cleaned_data.get('username'))))
            except User.DoesNotExist:
                pass

        if self.profile.user.email != cleaned_data.get('email'):
            try:
                User.objects.get(email=cleaned_data.get('email'))
                self.add_error('email', _('User already exist with this email {}'.format(cleaned_data.get('email'))))
            except User.DoesNotExist:
                pass

        if not self.profile.user.check_password(cleaned_data.get('passwd')):
            self.add_error('passwd', _('Password is incorrect'))
        return cleaned_data

    def _save(self, request):
        user_profile = super().save(commit=False)

        username = self.cleaned_data.get('username')
        email = self.cleaned_data.get('email')

        avatar = request.FILES.get('avatar')
        if avatar:
            user_profile_avatars = UserAvatars.objects.filter(user=user_profile.user)
            if user_profile_avatars.exists():
                for user_profile_avatar in user_profile_avatars:
                    user_profile_avatar.image =avatar
                    user_profile_avatar.save()
            else:
                UserAvatars.objects.create(**{
                    'image': avatar,
                    'user': user_profile.user
                })

        if username:
            user_profile.user.phone = username
        if email:
            user_profile.user.email = email
        user_profile.user.save()
        user_profile.save()
        return user_profile


class FileUploadForm(forms.ModelForm):

    class Meta:
        model = File
        fields = ['file']


class AlbumForm(forms.ModelForm):
    class Meta:
        model = Album
        fields = '__all__'


FileUploadFormSet = inlineformset_factory(Album, File, form=FileUploadForm, extra=4)


class ReviewForm(forms.ModelForm):
    comment = forms.CharField(widget=forms.Textarea(attrs={'class': 'chats-area'}), label='')

    class Meta:
        model = Review
        fields = ['comment', 'parent', ]


class CategoryForm(forms.ModelForm):
    class Meta:
        model = Category
        exclude = []
        field_classes = {
            'image_field': SVGAndImageFormField,
        }


class NotificationsAdminForm(forms.Form):
    text = forms.CharField(widget=forms.Textarea())
    count = forms.IntegerField(max_value=100)
    user_type = forms.ChoiceField(choices=User.USER_TYPE_CHOICES)