from django.conf.urls import url
from django.contrib.auth import views as auth_views
from django.contrib.auth.decorators import user_passes_test, login_required

from .views import *

login_forbidden = user_passes_test(lambda u: u.is_anonymous(), '/')

urlpatterns = [
    url(r'^login/$', LoginView.as_view(), name='login_page'),
    url(r'^register/$', RegisterView.as_view(), name='register_page'),
    url(r'^logout/$', auth_views.logout,  {'next_page': '/'}, name='logout',),
    url(r'^profile/$', login_required(ProfileView.as_view()), name='profile_page'),
    url(r'^profile/work-time/$', login_required(ProfileWeekTimeView.as_view()), name='profile_week_time_page'),
    url(r'^profile/location/$', login_required(ProfileLocationView.as_view()), name='profile_location_page'),
    url(r'^profile/password/$', login_required(ProfilePasswordView.as_view()), name='profile_password_page'),
    url(r'^notifications/$', login_required(NotificationsView.as_view()), name='company_notifications'),
    url(r'^notifications/(?P<pk>[\d]+)$', login_required(NotificationDetailView.as_view()),
        name='company_notifications_detail'),
    url(r'^gallery/$', login_required(GalleryView.as_view()), name='company_gallery'),
    url(r'^gallery/add/$', login_required(GalleryAddView.as_view()), name='company_gallery_add'),
    url(r'^gallery/(?P<file_id>[\d]+)/delete/$',
        login_required(GalleryDeleteView.as_view()), name='company_gallery_delete'),

    url(r'^password/reset/$', PasswordResetView.as_view(), name='password_reset', ),
    url(r'^password/done/$', PasswordResetDoneView.as_view(), name='password_reset_done', ),
    url(r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        PasswordResetConfirmView.as_view(), name='password_reset_confirm'),

    url(r'^reset/done/$', PasswordResetCompleteView.as_view(), name='password_reset_complete'),
]