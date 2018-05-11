# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from django.conf import settings
from django.utils.translation import ugettext as _
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from promotion.models import *


class Order(models.Model):
    ORDER_STATUS = (
        ("0", _('Available')),
        ("1", _('Awaiting Payment')),
        ("2", _('Payment completed')),
        ("3", _('Cancelled')),
    )
    customer = models.ForeignKey(settings.AUTH_USER_MODEL, blank=True, null=True)

    total_price = models.FloatField(null=True, blank=True)
    created = models.DateTimeField(auto_now_add=True)
    state = models.CharField(choices=ORDER_STATUS, max_length=20, default=ORDER_STATUS[0][0], blank=True)

    promotion_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    promotion_id = models.PositiveIntegerField()

    order = GenericForeignKey('promotion_type', 'promotion_id')

    def str(self):
        return "Order - {}".format(self.pk)

    def __unicode__(self):
        return "Order - {}".format(self.pk)

    def get_order_status(self, status_key):
        status_value = status_key
        for status in self.ORDER_STATUS:
            if status[0] == status_key:
                status_value = status[1]
                break
        return status_value


class PaycomTransaction(models.Model):
    paycom_transaction_id = models.CharField(max_length=255, null=False, unique=True)
    paycom_time = models.CharField(max_length=15)
    paycom_time_datetime = models.DateTimeField(null=False)
    create_time = models.DateTimeField(null=False)
    perform_time = models.DateTimeField(null=True, blank=True)
    cancel_time = models.DateTimeField(null=True, blank=True)
    amount = models.CharField(max_length=50, null=False)
    state = models.IntegerField(null=False)
    reason = models.IntegerField(null=True, blank=True)
    receivers = models.TextField(null=True, blank=True)

    order = models.ForeignKey(Order, null=True)

    def str(self):
        return "Transaction id {}".format(self.pk)

