from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^output', views.output, name='outputname'),
    url(r'^post/ajax/gcommand/$', views.add_command, name="add_command"),
    url(r'^get/ajax/validate/command', views.check_command, name="validate_command"),
]