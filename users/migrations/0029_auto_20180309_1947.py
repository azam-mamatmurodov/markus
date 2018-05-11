# -*- coding: utf-8 -*-
# Generated by Django 1.11.9 on 2018-03-09 19:47
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0028_auto_20180306_1111'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='image',
            name='image',
        ),
        migrations.RemoveField(
            model_name='user',
            name='avatar',
        ),
        migrations.AddField(
            model_name='image',
            name='file',
            field=models.FileField(blank=True, null=True, upload_to='album/%y/%m/%d'),
        ),
    ]