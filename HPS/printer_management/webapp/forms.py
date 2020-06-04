from .models import command
from django import forms
import datetime

class UploadFileForm(forms.Form):
    title = forms.CharField(max_length=50)
    file = forms.FileField()