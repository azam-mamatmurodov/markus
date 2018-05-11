# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from django.contrib.contenttypes.models import ContentType

from payment.models import PaycomTransaction, Order
# Register your models here.


class PaycomTransactionAdmin(admin.ModelAdmin):
    list_display = ['customer', 'create_time', 'amount', 'state', 'order']

    @staticmethod
    def customer(obj):
        return obj.order.customer.first_name


class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'get_customer', 'total_price', 'state']

    def get_customer(self, obj):
        return obj.customer.id


admin.site.register(PaycomTransaction, PaycomTransactionAdmin)
admin.site.register(Order, OrderAdmin)
