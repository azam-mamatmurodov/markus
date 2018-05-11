from django.conf.urls import url
from .views import api

urlpatterns = [
    url(r'^api/v1/paycom/$', view=api)
]
