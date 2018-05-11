from django.conf import settings
from django.contrib.auth import get_user_model

from celery import shared_task
from pyfcm import FCMNotification

from users.models import Notifications

push_service = FCMNotification(api_key=settings.FCM_APIKEY)

User = get_user_model()

users = User.objects.filter(company__isnull=True).order_by('?')


@shared_task
def send_notifications_2_users(users_count, message):
    notification_users = users[:users_count]
    for notification_user in notification_users:
        try:
            result = push_service.notify_topic_subscribers(topic_name=notification_user.phone,
                                                           message_body=message,
                                                           sound="Default", tag='true')
            print(result)
        except:
            print('cannot sent')
            pass


@shared_task
def send_notifications_2_users_from_admin(sender_id, users_count, message, text):
    sender_user = User.objects.get(pk=sender_id)
    notification_users = users[:users_count]
    for notification_user in notification_users:
        try:
            result = push_service.notify_topic_subscribers(topic_name=notification_user.phone,
                                                           message_body=message,
                                                           sound="Default", tag='true')
            print(result)
        except:
            print('cannot sent')
            pass
        if sender_user:
            Notifications.objects.create(**{
                'title': 'Notifications from Administrator',
                'user': notification_user,
                'notification_sender': sender_user,
                'text': text
            })