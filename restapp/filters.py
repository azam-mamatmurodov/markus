from django_filters import filterset, filters

from users.models import Category


class CategoryFilter(filterset.Filter):
    is_top = filters.BooleanFilter(name="is_top")

    class Meta:
        model = Category
        fields = ['is_top']