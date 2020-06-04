from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^output', views.output, name='outputname'),
    url(r'^post/ajax/gcommand/$', views.add_command, name="add_command"),
    url(r'^apply_settings/', views.apply_settings, name='apply_settings'),
    url(r'^fileupload', views.upload_file, name='fileupload'),
    url(r'^buttons_processing', views.buttons_processing, name='buttons_processing'),
    url(r'^setprint', views.setprint, name='setprint'),
    url(r'^update', views.updateHTML, name='update'),
]