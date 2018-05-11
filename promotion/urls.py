from django.conf.urls import url
from django.contrib.auth.decorators import user_passes_test, login_required
from promotion.views import *

urlpatterns = [
    url(r'promote/notifications/send/$',
        login_required(PromotionNotificationsView.as_view()),
        name='notifications_promotion'),
    url(r'promote/notifications/history/$',
        login_required(PromotionNotificationsHistoryView.as_view()),
        name='notifications_promotion_history'),

    url(r'promote/search/$',
        login_required(PromotionInSearchView.as_view()),
        name='search_promotion'),
    url(r'promote/search/history/$',
        login_required(PromotionInSearchHistoryView.as_view()),
        name='search_promotion_history'),

    url(r'promote/category/$',
        login_required(PromotionInCategoryView.as_view()),
        name='category_promotion'),
    url(r'promote/category/history/$',
        login_required(PromotionInCategoryHistoryView.as_view()),
        name='category_promotion_history'),

    url(r'promote/payment/$',
        login_required(PaymentView.as_view()),
        name='promotion_payment'),
]