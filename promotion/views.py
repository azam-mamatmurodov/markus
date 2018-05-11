import re

from django.shortcuts import render, reverse, Http404
from django.views import generic
from django.conf import settings
from django.contrib.auth import get_user_model

from promotion.models import NotificationPromotion, CompanyPromotion, PromotionType, NotificationPromotionPlan
from promotion.forms import NotificationPromotionForm, CompanyPromotionForm
from users.models import Notifications
from .tasks import send_notifications_2_users

from pyfcm import FCMNotification

push_service = FCMNotification(api_key=settings.FCM_APIKEY)

User = get_user_model()


def notification_sender_by_topic(topic_name, **kwargs):
    message_body = kwargs.get('text')
    try:
        result = push_service.notify_topic_subscribers(topic_name=topic_name, message_body=message_body, sound="Default", tag='true')
        print(result)
        print(topic_name)
    except:
        pass


class PromotionNotificationsView(generic.CreateView):
    template_name = 'pages/promotions/promote_notifications.html'
    model = NotificationPromotion
    form_class = NotificationPromotionForm

    def get_success_url(self):
        return reverse('promotions:notifications_promotion_history')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        users = User.objects.filter(company__isnull=True).order_by('?')
        context['count_of_users'] = users.count()
        context['notification_promotion'] = NotificationPromotionPlan.objects.all().first()
        return context

    def form_valid(self, form):
        clients_count = int(form.data.get('count_of_users'))
        clients_text = form.data.get('text')
        try:
            promotion_price = NotificationPromotionPlan.objects.all().first().price.real
        except PromotionType.DoesNotExist:
            promotion_price = 1

        promotion_instance = form.save(commit=False)
        promotion_instance.total_amount = promotion_price * clients_count
        promotion_instance.company = self.request.user.company
        promotion_instance.counter = clients_count
        promotion_instance.text = clients_text
        promotion_instance.status = True
        if self.request.FILES.get('image'):
            promotion_instance.image = self.request.FILES.get('image')
        promotion_instance.save()

        users = User.objects.filter(company__isnull=True).order_by('?')

        notification_users = users[:clients_count]
        pattern = re.compile(r"^[^.]*")
        text = re.search(pattern, clients_text).group(0)

        send_notifications_2_users.delay(clients_count, text)

        for notification_user in notification_users:

            backend_notification_kwargs = {
                'text': clients_text,
                'title': 'Notification from {}'.format(self.request.user.company.company_name),
                'user': notification_user,
                'notification_sender': self.request.user
            }
            if self.request.FILES.get('image'):
                backend_notification_kwargs.update({
                    'image': self.request.FILES.get('image')
                })
            Notifications.objects.create(**backend_notification_kwargs)
        return super().form_valid(form)


class PromotionNotificationsHistoryView(generic.ListView):
    model = NotificationPromotion
    template_name = 'pages/promotions/promote_notifications_history.html'
    context_object_name = 'promotions'
    paginate_by = 10

    def get_queryset(self):
        return self.model.objects.filter(company__user=self.request.user).order_by('-pk')


class PromotionInSearchView(generic.CreateView):
    template_name = 'pages/promotions/promote_on_search.html'
    model = CompanyPromotion
    form_class = CompanyPromotionForm

    def get_success_url(self):
        return reverse('promotions:search_promotion_history')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['promote_type'] = PromotionType.objects.filter(promote_type='show_in_search').first()
        return context

    def form_valid(self, form):
        try:
            promotion_type = PromotionType.objects.get(promote_type='show_in_search')
            if form.data.get('action_type') == 'click':
                promotion_price = promotion_type.click_price.real
            else:
                promotion_price = promotion_type.view_price.real
        except PromotionType.DoesNotExist:
            raise Http404()
        promotion_instance = form.save(commit=False)
        promotion_instance.promotion_type = promotion_type
        promotion_instance.action_type = form.data.get('action_type')
        promotion_instance.total_amount = promotion_price * promotion_instance.count_of_action
        promotion_instance.company = self.request.user.company
        promotion_instance.counter = promotion_instance.count_of_action
        promotion_instance.status = True
        promotion_instance.save()
        return super().form_valid(form=form)


class PromotionInSearchHistoryView(generic.ListView):
    model = CompanyPromotion
    template_name = 'pages/promotions/promote_on_search_history.html'
    context_object_name = 'promotions'
    paginate_by = 10

    def get_queryset(self):
        return self.model.objects.filter(company__user=self.request.user,
                                         promotion_type__promote_type='show_in_search').order_by('-pk')


class PromotionInCategoryView(generic.CreateView):
    template_name = 'pages/promotions/promote_on_category.html'
    model = CompanyPromotion
    form_class = CompanyPromotionForm

    def get_success_url(self):
        return reverse('promotions:category_promotion_history')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['promote_type'] = PromotionType.objects.filter(promote_type='show_in_related').first()
        return context

    def form_valid(self, form):
        try:
            promotion_type = PromotionType.objects.get(promote_type='show_in_related')
            if form.data.get('action_type') == 'click':
                promotion_price = promotion_type.click_price.real
            else:
                promotion_price = promotion_type.view_price.real
        except PromotionType.DoesNotExist:
            raise Http404()
        promotion_instance = form.save(commit=False)
        promotion_instance.promotion_type = promotion_type
        promotion_instance.action_type = form.data.get('action_type')
        promotion_instance.total_amount = promotion_price * promotion_instance.count_of_action
        promotion_instance.company = self.request.user.company
        promotion_instance.counter = promotion_instance.count_of_action
        promotion_instance.status = True
        promotion_instance.save()
        return super().form_valid(form=form)


class PromotionInCategoryHistoryView(generic.ListView):
    model = CompanyPromotion
    template_name = 'pages/promotions/promote_on_category_history.html'
    context_object_name = 'promotions'
    paginate_by = 10

    def get_queryset(self):
        return self.model.objects.filter(company__user=self.request.user, promotion_type__promote_type='show_in_related').order_by('-pk')



class PaymentView(generic.TemplateView):
    template_name = 'pages/payment.html'
