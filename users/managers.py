from datetime import datetime, date

from django.db import models
from django.db.models import Q, Avg
from django.utils.translation import ugettext_lazy as _
from django.apps import apps


from geosimple.managers import GeoManager



WEEK_DAYS = (
    ('monday', _('Monday'),),
    ('tuesday', _('Tuesday'),),
    ('wednesday', _('Wednesday'),),
    ('thursday', _('Thursday'),),
    ('friday', _('Friday'),),
    ('saturday', _('Saturday'),),
    ('sunday', _('Sunday'),),
)

def get_week_day(day):
    for key, week_day in enumerate(WEEK_DAYS):
        if key == day:
            return week_day[0]
    return None

current_day = date.today().weekday()
current_week_day = get_week_day(current_day)


class CompanyManager(GeoManager):
    def get_nearby_locations(self, location_lat_long, distance, **kwargs):
        company = apps.get_model(app_label='users', model_name='company')
        queryset = self.get_queryset().filter(location__distance_lt=(location_lat_long, distance), status=company.ACTIVE)
        #distance in kilometres
        if kwargs.get('rate') or kwargs.get('states'):
            week_time_model = apps.get_model(app_label='users', model_name='weektime')
            queryset = queryset
            if kwargs.get('rate'):
                rate = kwargs.get('rate', 0)
                queryset = queryset.annotate(total_rate=Avg('review__rate')).filter(
                    Q(total_rate__lte=rate) | Q(total_rate=None))

            if kwargs.get('states'):
                now = datetime.now().time()
                states = kwargs.get('states').split(',')
                open_companies = closed_companies = unknown_companies = list()

                current_day_available_companies_queryset = week_time_model.objects.filter(day=current_week_day)

                if states.__contains__('open'):
                    open_companies = current_day_available_companies_queryset.filter(opening_time__lte=now,
                                                                                     closing_time__gte=now).values_list(
                        'company', flat=True)
                if states.__contains__('closed'):
                    open_companies_queryset = current_day_available_companies_queryset.filter(opening_time__lte=now,
                                                                                              closing_time__gte=now).values_list(
                        'company', flat=True)
                    closed_companies_queryset = current_day_available_companies_queryset.values_list('company',
                                                                                                     flat=True)
                    closed_companies = list(set(closed_companies_queryset) - set(open_companies_queryset))

                if states.__contains__('unknown'):
                    current_day_available_companies = current_day_available_companies_queryset.distinct(
                        'company').values_list('company', flat=True)
                    unknown_companies = queryset.exclude(pk__in=current_day_available_companies).values_list('id',
                                                                                                             flat=True)
                all_companies = list(open_companies) + list(closed_companies) + list(unknown_companies)
                queryset = queryset.filter(pk__in=all_companies)
        return queryset


class AlbumManager(models.Manager):

    def get_company_images(self, company_user):
        return self.get_queryset().filter(company__user=company_user).values_list('files_set')