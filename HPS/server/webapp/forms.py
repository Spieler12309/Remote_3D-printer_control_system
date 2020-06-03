from .models import command
from django import forms
import datetime


class GcodeCommandForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(GcodeCommandForm, self).__init__(*args, **kwargs)
        ## add a "form-control" class to each form input
        ## for enabling bootstrap
        # for name in self.fields.keys():
        #     self.fields[name].widget.attrs.update({
        #         'class': 'form-control',
        #     })

    class Meta:
        model = command
        fields = ("__all__")