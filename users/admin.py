# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import re

from django.contrib import admin
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
from django.utils.translation import ugettext_lazy as _
from django.conf.urls import url
from django.shortcuts import render, redirect


from mptt.admin import DraggableMPTTAdmin
from djcelery.models import (
    TaskState, WorkerState, PeriodicTask,
    IntervalSchedule, CrontabSchedule)
from rest_framework.authtoken import models as rest_auth_models

from .models import *
from .forms import CategoryForm, NotificationsAdminForm
from promotion.tasks import send_notifications_2_users_from_admin


class AvatarsInline(admin.StackedInline):
    model = UserAvatars
    max_num = 1

    verbose_name = _('User picture')
    verbose_name_plural = _('User pictures')


class WeekTimeInline(admin.TabularInline):
    model = WeekTime
    max_num = min_num = 7

    verbose_name = _('Company weekly work time')
    verbose_name_plural = _('Company weekly work time ')


@admin.register(User)
class UserAdmin(DjangoUserAdmin, admin.ModelAdmin):
    inlines = [AvatarsInline]
    fieldsets = (
        (_('Main'), {'fields': ('email', 'password')}),
        (_('Personal info'), {'fields': ('first_name', 'last_name', 'user_type', 'phone',)}),
        (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser',
                                       'groups', 'user_permissions')}),
        (_('Important dates'), {'fields': ('last_login',)}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2', 'phone', 'first_name', 'last_name', 'user_type',),
        }),
    )
    list_display = ('get_username', 'get_fullname', 'is_staff', 'user_type', 'date_joined', 'get_business_owner')
    list_filter = ('user_type',)
    search_fields = ('email', 'first_name', 'last_name', 'phone',)
    list_editable = ['user_type']
    ordering = ('email',)

    def get_username(self, obj):
        if obj.user_type == User.COMPANY:
            return obj.email
        return obj.phone

    def get_fullname(self, obj):
        return "{} {}".format(obj.first_name, obj.last_name)

    def get_business_owner(self, obj):
        if obj.company:
            return 'Yes'
        return 'No'

    get_business_owner.short_description = 'Business owner'


class FileAdmin(admin.StackedInline):
    fields = ['file',]
    model = File
    extra = 5


class AlbumAdmin(admin.ModelAdmin):
    inlines = [FileAdmin, ]
    fieldsets = (
        ('Author details', {'fields': ('owner', 'company',), }),
    )
    list_display = ('id', 'owner', 'created_at', 'updated_at', 'company', )
    list_filter = ['company']

    class Meta:
        model = Album


class ReviewAdmin(admin.ModelAdmin):
    list_display = ['get_author', 'company', 'created_at', ]

    @staticmethod
    def get_author(obj):
        return obj.author.first_name


class ReviewLikeDislikeAdmin(admin.ModelAdmin):
    list_display = ['like_dislike_user', 'review', 'rate', ]


class NotificationsAdmin(admin.ModelAdmin):
    empty_value_display = '-empty-'
    list_display = ['title', 'get_receiver', 'get_sender']
    
    class Meta:
        verbose_name='Notification'
        verbose_name_plural = 'Notifications'
    
    def get_receiver(self, obj):
        return obj.user.get_full_name()

    get_receiver.short_description = 'Receiver'

    def get_sender(self, obj):
        if obj.notification_sender:
            return obj.notification_sender.get_full_name()
        return None

    get_sender.short_description = 'Sender'

    change_list_template = 'admin/notifications/change_list.html'

    def get_urls(self):
        urls = super().get_urls()
        my_urls = [
            url('send/', self.send_notifications),
        ]
        return my_urls + urls
    
    def send_notifications(self, request):

        if request.method == 'POST':
            form = NotificationsAdminForm(request.POST)
            if form.is_valid():
                # Creation notifications for business or clients
                count = int(form.data.get('count'))
                text = form.data.get('text')
                user_type = form.data.get('user_type')

                users = User.objects.filter(user_type=user_type)

                if count <= users.count():
                    receivers = users[:count]
                else:
                    receivers = users
                if int(user_type) == User.COMPANY:
                    for receiver in receivers:
                        Notifications.objects.create(**{
                            'title': 'Notifications from Administrator',
                            'user': receiver,
                            'notification_sender': request.user,
                            'text': text
                        })
                else:
                    pattern = re.compile(r"^[^.]*")
                    message = re.search(pattern, text).group(0)
                    send_notifications_2_users_from_admin.delay(request.user.id, receivers.count(), message, text)

                self.message_user(request, "Notifications have been sent to {} users!".format(receivers.count()))
                return redirect('/admin/users/notifications/')
            context = {'form': form}
            return render(request, 'admin/notifications/notifications_send.html', context)
        form = NotificationsAdminForm()
        context = {'form': form}
        return render(request, 'admin/notifications/notifications_send.html', context)


class FileAdminPanel(admin.ModelAdmin):
    list_display = ['get_company']
    list_filter = ['album']

    def get_company(self, obj):
        return obj.album.company


class CompanyAdmin(admin.ModelAdmin):
    inlines = [WeekTimeInline, ]
    ordering = ['-id']
    list_display = ['id', 'company_name', 'status',]
    list_filter = ['status', 'category', ]
    list_editable = ['status']

    class Meta:
        verbose_name='Company'
        verbose_name_plural = 'Companies'


class CategoryAdmin(admin.ModelAdmin):
    form = CategoryForm
    
    class Meta:
        verbose_name='Category'
        verbose_name_plural = 'Categories'


class UserAvatarsAdmin(admin.ModelAdmin):
    pass
    
    class Meta:
        verbose_name = 'Users avatar'
        verbose_name_plural = 'Users avatar'


admin.site.unregister(TaskState)
admin.site.unregister(WorkerState)
admin.site.unregister(IntervalSchedule)
admin.site.unregister(CrontabSchedule)
admin.site.unregister(PeriodicTask)
admin.site.unregister(Group)
admin.site.unregister(rest_auth_models.Token)


admin.site.register(Category, DraggableMPTTAdmin)
admin.site.register(Company, CompanyAdmin)
admin.site.register(Client)
admin.site.register(UserAvatars, UserAvatarsAdmin)
admin.site.register(Review, ReviewAdmin)
admin.site.register(Album, AlbumAdmin)
admin.site.register(ReviewLikeDislike, ReviewLikeDislikeAdmin)
admin.site.register(Notifications, NotificationsAdmin)
admin.site.register(File, FileAdminPanel)