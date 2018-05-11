from rest_framework import pagination


class CompaniesPagination(pagination.PageNumberPagination):
    page_size = 15


class CompanyReviewsPagination(pagination.PageNumberPagination):
    page_size = 5
