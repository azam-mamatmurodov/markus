from django.conf.urls import url, include
from django.conf.urls.static import static
from django.contrib import admin
from django.conf import settings
from django.views.generic import RedirectView

from rest_framework.authtoken import views
from rest_framework_swagger.views import get_swagger_view

api_title = 'MarkUs API documentation'
schema_view = get_swagger_view(title=api_title)

urlpatterns = [
    url('^$', RedirectView.as_view(url='/reviews/latest/',)),
    url(r'^admin/', admin.site.urls),
    url(r'', include('main.urls', namespace='main')),
    url(r'', include('users.urls', namespace='users')),
    url(r'', include('promotion.urls', namespace='promotions')),

]
urlpatterns += [
    url(r'^api-token-auth/', views.obtain_auth_token),
    url(r'^api/v1/', include('restapp.urls', namespace='rest_api_urls')),
    url(r'^api/v1/docs/', schema_view),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL,
                          document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)
    # import debug_toolbar
    # urlpatterns += [
    #     url(r'^__debug__/', include(debug_toolbar.urls)),
    # ]
