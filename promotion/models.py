from decimal import Decimal
from django.db import models
from django.utils.translation import ugettext as _
from django.db.models.signals import post_save

from users.models import Company


ACTION_TYPES = (
    ('click', _('Per click')),
    ('view', _('Per view')),
)
PROMOTE_TYPES = (
    ('show_in_search', _('Show in search')),
    ('show_in_related', _('Show in related')),
)


class PromotionType(models.Model):
    promote_type = models.CharField(choices=PROMOTE_TYPES, max_length=40, default='', unique=True)
    view_price = models.DecimalField(decimal_places=2, max_digits=10, help_text='Uzs', default=Decimal(1))
    click_price = models.DecimalField(decimal_places=2, max_digits=10, help_text='Uzs', default=Decimal(1))
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True)
    updated_at = models.DateTimeField(auto_created=True, auto_now=True,)

    def __str__(self):
        return self.promote_type


class NotificationPromotionPlan(models.Model):
    price = models.DecimalField(decimal_places=2, max_digits=10, help_text='Uzs', default=Decimal(1))
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True)
    updated_at = models.DateTimeField(auto_created=True, auto_now=True,)


class NotificationPromotion(models.Model):
    company = models.ForeignKey(Company)
    count_of_users = models.PositiveIntegerField(default=0)
    total_amount = models.DecimalField(decimal_places=2, max_digits=10)
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True)
    counter = models.PositiveIntegerField(default=0)
    status = models.BooleanField(default=False)
    text = models.TextField()
    image = models.ImageField(blank=True, null=True, upload_to='promotions/notifications/')

    def get_status(self):
        return 'Active' if self.status else 'Not active'


class CompanyPromotion(models.Model):
    action_type = models.CharField(choices=ACTION_TYPES, max_length=40, default='')
    count_of_action = models.PositiveIntegerField(default=0)
    promotion_type = models.ForeignKey(PromotionType)
    total_amount = models.DecimalField(decimal_places=2, max_digits=10)
    company = models.ForeignKey(Company)
    counter = models.PositiveIntegerField(default=0)
    status = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_created=True, auto_now_add=True)

    def __str__(self):
        return self.get_action()

    def get_action(self):
        action = self.action_type
        for ACTION_TYPE in ACTION_TYPES:
            if action == ACTION_TYPE[0]:
                return ACTION_TYPE[1]
        return action

    def get_status(self):
        return 'Active' if self.status else 'Not active'


def promotion_save(instance, raw, created, using, update_fields):
    pass


