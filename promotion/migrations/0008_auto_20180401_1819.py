# -*- coding: utf-8 -*-
# Generated by Django 1.11.9 on 2018-04-01 13:19
from __future__ import unicode_literals

import datetime
from decimal import Decimal
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('promotion', '0007_auto_20180401_1751'),
    ]

    operations = [
        migrations.CreateModel(
            name='NotificationPromotionPlan',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('updated_at', models.DateTimeField(auto_created=True, auto_now=True)),
                ('created_at', models.DateTimeField(auto_created=True, auto_now_add=True)),
                ('price', models.DecimalField(decimal_places=2, default=Decimal('1'), help_text='Uzs', max_digits=10)),
            ],
        ),
        migrations.AddField(
            model_name='companypromotion',
            name='action_type',
            field=models.CharField(choices=[('click', 'Per click'), ('view', 'Per view')], default='', max_length=40),
        ),
        migrations.AddField(
            model_name='promotiontype',
            name='created_at',
            field=models.DateTimeField(auto_created=True, auto_now_add=True, default=datetime.datetime(2018, 4, 1, 13, 19, 15, 234249, tzinfo=utc)),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='promotiontype',
            name='updated_at',
            field=models.DateTimeField(auto_created=True, auto_now=True),
        ),
    ]