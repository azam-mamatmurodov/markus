import os
import json
from django.http.response import JsonResponse
from django.conf import settings
from rest_framework import views, response, generics, viewsets

from . import serializers
from .paycom.Application import Application


class PaycomView(views.APIView):

    def get(self, request, *args, **kwargs):
        return response.Response(data={'message': 'Failed'})

    def post(self, request, *args, **kwargs):
        # Write request to file

        with open(os.path.join(settings.MEDIA_ROOT, 'request.txt'), 'w') as f:
            body_unicode = request.body.decode('utf-8')

            f.write(body_unicode)

        app = Application(request=request)
        print(app.request.method)
        data = app.run()
        import json
        new_data = json.loads(data)
        return JsonResponse(data=new_data, safe=False)


class PaycomSubscribeView(views.APIView):

    def get(self, request, *args, **kwargs):
        return response.Response(data={'message': 'Failed'})

    def post(self, request, *args, **kwargs):
        import requests
        import json
        payload = request.POST.get('data')
        url = "https://checkout.test.paycom.uz/api"

        headers = {
            'X-Auth': "5acf89d5dcd4709f64b02cc5",
            'Content-Type': "application/json",
            'Cache-Control': "no-cache"
        }

        response = requests.request("POST", url, data=payload, headers=headers)
        response_obj = json.loads(response.text)
        print(payload)
        print(response_obj)
        return JsonResponse(data=response_obj, safe=False)