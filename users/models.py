# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from users.managers import CompanyManager, AlbumManager

from django.db import models
from django.contrib.auth.models import AbstractUser, PermissionsMixin, BaseUserManager
from django.utils.translation import ugettext_lazy as _
from django.conf import settings

from mptt.models import MPTTModel, TreeForeignKey
from ckeditor.fields import RichTextField
from geosimple.fields import GeohashField


import os

GENDERS = (
    ('male', _('Male')),
    ('female', _('Female')),
)

WEEK_DAYS = (
    ('monday', _('Monday'),),
    ('tuesday', _('Tuesday'),),
    ('wednesday', _('Wednesday'),),
    ('thursday', _('Thursday'),),
    ('friday', _('Friday'),),
    ('saturday', _('Saturday'),),
    ('sunday', _('Sunday'),),
)


def get_week_day(day):
    for key, week_day in enumerate(WEEK_DAYS):
        if key == day:
            return week_day[0]
    return None


class UserAvatars(models.Model):
    image = models.ImageField(upload_to='users/%y/%m/%d', default='default.png')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, null=True, blank=True, related_name='user_avatar')

    def __str__(self):
        if self.user:
            return "{}".format(self.user.get_full_name())
        return ""


class Album(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True, auto_now=False, editable=True)
    updated_at = models.DateTimeField(auto_created=True, auto_now_add=False, auto_now=True, editable=True)
    company = models.ForeignKey('Company', on_delete=models.CASCADE, null=True, blank=True)

    def get_files(self, obj):
        return File.objects.filter(album=self)

    def __str__(self):
        return "Album - {}".format(self.id)

    objects = AlbumManager()


class File(models.Model):
    file = models.FileField(upload_to='album/%y/%m/%d', null=True, blank=True, default='default.png')
    album = models.ForeignKey(Album, on_delete=models.CASCADE)

    def extension(self):
        name, extension = os.path.splitext(self.file.name)
        return extension

    def is_image(self):
        if self.extension().lower() in ['.png', '.jpg', '.jpeg']:
            return True
        return False


class UserManager(BaseUserManager):
    """Define a model manager for User model with no username field."""

    use_in_migrations = True

    def _create_user(self, username, password, **extra_fields):
        user = self.model(email=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, username, password=None, **extra_fields):
        """Create and save a regular User with the given email and password."""
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(username, password, **extra_fields)

    def create_superuser(self, email, password, **extra_fields):
        """Create and save a SuperUser with the given email and password."""
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self._create_user(email, password, **extra_fields)


class User(AbstractUser):
    COMPANY = 1
    USER = 2
    USER_TYPE_CHOICES = (
        (COMPANY, _('Company')),
        (USER, _('User')),
    )
    username = None
    phone = models.CharField(max_length=12, unique=True)
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPE_CHOICES, default=USER)
    first_name = models.CharField(_('first name'), max_length=30, blank=True)
    last_name = models.CharField(_('last name'), max_length=30, blank=True)
    date_joined = models.DateTimeField(_('date joined'), auto_now_add=True)
    is_active = models.BooleanField(_('active'), default=True)

    USERNAME_FIELD = 'phone'
    objects = UserManager()
    REQUIRED_FIELDS = ['email']

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')

    def __str__(self):
        return "{}-{}".format(self.phone, self.get_full_name())

    def get_avatar(self, request):
        try:
            file = self.user_avatar.first().image
        except (UserAvatars.DoesNotExist, AttributeError):
            return None
        return request.build_absolute_uri(file.url)

    def get_image(self):
        try:
            file = self.user_avatar.first().image
        except (UserAvatars.DoesNotExist, AttributeError):
            return None
        return file.url


class Category(MPTTModel):
    name = models.CharField(max_length=50, unique=True)
    parent = TreeForeignKey('self', null=True, blank=True, related_name='children', db_index=True)
    is_top = models.BooleanField(default=False)
    icon = models.ImageField(upload_to='category/', default='default.png')
    svg_icon = models.FileField(upload_to='category/', default='default.png')

    class MPTTMeta:
        order_insertion_by = ['name']

    def __str__(self):
        return "{}".format(self.name)


class WeekTime(models.Model):
    day = models.CharField(choices=WEEK_DAYS, max_length=15,)
    opening_time = models.TimeField(null=True, blank=True)
    closing_time = models.TimeField(null=True, blank=True)
    is_default = models.BooleanField(default=False)
    company = models.ForeignKey('Company')

    def __str__(self):
        return self.day


class Company(models.Model):
    BLOCKED = 0
    ACTIVE = 1
    PENDING = 2
    STATUS = (
        (BLOCKED, _('Blocked')),
        (ACTIVE, _('Active')),
        (PENDING, _('Pending')),
    )
    user = models.OneToOneField(settings.AUTH_USER_MODEL, null=True)
    company_name = models.CharField(max_length=255)
    category = models.ForeignKey(Category, related_name='company_category')
    description = RichTextField()
    address = models.TextField(null=True, blank=True, )
    call_center = models.CharField(max_length=13)
    website = models.URLField(null=True, blank=True)
    status = models.IntegerField(choices=STATUS, default=BLOCKED)
    location = GeohashField(default={'latitude': 50.822482, 'longitude': -0.141449}, editable=False)

    objects = CompanyManager()

    def __str__(self):
        return "{} - {}".format(self.user, self.company_name)

    @property
    def get_total_rate(self):

        total_rate = 0
        rates = Review.objects.filter(company=self).values('rate')
        if len(rates) > 0:
            for rate in rates:
                total_rate += rate['rate']
            total_rate = total_rate / len(rates)
        return total_rate

    def company_changed(self):
        self.status = self.PENDING
        self.save()


class Review(MPTTModel):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='review_author')
    parent = TreeForeignKey('self', null=True, blank=True, related_name='review_parent', db_index=True)
    comment = models.TextField()
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True, auto_now=False)
    album = models.ForeignKey(Album, null=True, blank=True, related_name='review_album')
    company = models.ForeignKey(Company,)
    rate = models.FloatField(default=0)

    def get_files(self, obj):
        return File.objects.all()


class Client(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, related_name='client', on_delete=models.CASCADE)
    date_of_birthday = models.DateField(_('date of birthday'), null=True, blank=True,)
    gender = models.CharField(choices=GENDERS, max_length=6, null=True, blank=True,)

    def __str__(self):
        return "{}".format(self.user)


class Bookmarks(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='bookmark_owner',)
    company = models.ForeignKey(Company, related_name='bookmarked_company',)


class ReviewLikeDislike(models.Model):
    like_dislike_user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='review_like_dislike_user')
    rate = models.IntegerField(default=0)
    review = models.ForeignKey(Review, on_delete=models.CASCADE)


class RecentlyViewed(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='user_recently_viewed', on_delete=models.CASCADE)
    company = models.ForeignKey(Company, on_delete=models.CASCADE)


class Notifications(models.Model):
    title = models.CharField(max_length=60)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='notification_user', on_delete=models.CASCADE)
    notification_sender = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='notification_sender', null=True, blank=True,)
    text = models.TextField()
    image = models.ImageField(blank=True, null=True, upload_to='notifications/')
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True, auto_now=False)
    is_read = models.BooleanField(default=False)


