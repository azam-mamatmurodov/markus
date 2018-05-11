from django import forms
from django.contrib.auth import get_user_model

from promotion.models import NotificationPromotion, CompanyPromotion

User = get_user_model()


class NotificationPromotionForm(forms.ModelForm):
    users = User.objects.filter(company__isnull=True).order_by('?')
    count_of_users = forms.IntegerField(max_value=users.count())

    class Meta:
        model = NotificationPromotion
        fields = ['count_of_users', 'text', 'image']


class CompanyPromotionForm(forms.ModelForm):
    count_of_action = [(1, 1)]
    for number in range(10, 110, 10):
        count_of_action.append((number, number))
    count_of_action = forms.ChoiceField(widget=forms.Select(), choices=count_of_action)

    class Meta:
        model = CompanyPromotion
        fields = ['count_of_action', ]