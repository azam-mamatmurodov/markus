from django.contrib import admin
from promotion.models import *


class PromotionTypeAdmin(admin.ModelAdmin):
    list_display = ['promote_type', 'get_view_price', 'get_click_price', 'created_at', 'updated_at', ]

    def has_delete_permission(self, request, obj=None):
        return False

    def get_actions(self, request):
        actions = super().get_actions(request)
        del actions['delete_selected']
        return actions

    def get_promote_type(self, obj):
        return "For per {}".format(obj.promote_type)

    get_promote_type.short_description = 'Promote type'

    def get_view_price(self, obj):
        return "{} uzs".format(obj.view_price)
    get_view_price.short_description = 'View price'

    def get_click_price(self, obj):
        return "{} uzs".format(obj.click_price)
    get_click_price.short_description = 'Click price'


class CompanyPromotionAdmin(admin.ModelAdmin):
    list_display = ['company', 'promotion_type', 'action_type', 'count_of_action', 'total_amount', 'counter', 'status', 'created_at', ]
    list_filter = ['promotion_type', 'created_at', ]


class NotificationPromotionPlanAdmin(admin.ModelAdmin):
    list_display = ['get_price', 'created_at', 'updated_at']

    def has_add_permission(self, request):
        return NotificationPromotionPlan.objects.all().count() == 0

    def has_delete_permission(self, request, obj=None):
        return False

    def get_actions(self, request):
        actions = super().get_actions(request)
        del actions['delete_selected']
        return actions

    def get_price(self, obj):
        return "{} uzs".format(obj.price)

    get_price.short_description = 'Per notification'


class NotificationPromotionAdmin(admin.ModelAdmin):
    list_display = ['company', 'count_of_users', 'total_amount', 'created_at', 'status', ]


admin.site.register(NotificationPromotion, NotificationPromotionAdmin)
admin.site.register(NotificationPromotionPlan, NotificationPromotionPlanAdmin)
admin.site.register(CompanyPromotion, CompanyPromotionAdmin)
admin.site.register(PromotionType, PromotionTypeAdmin)