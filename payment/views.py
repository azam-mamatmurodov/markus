# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import HttpResponse
from django.views.decorators.csrf import csrf_exempt


from paycom.Application import Application


@csrf_exempt
def api(request):
    app = Application(request=request)
    content = app.run()
    with open('./Request.txt', 'a+') as f:
        data = "Request: " + request.body + "\n" + "Response: " + content + "\n" + "Header: " + \
               request.META.get('HTTP_AUTHORIZATION') + "\n"
        f.write(data)
        f.close()
    return HttpResponse(content=content, content_type='text/json')
