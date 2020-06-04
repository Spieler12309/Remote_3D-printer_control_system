from django.db import models

# Create your models here
class command(models.Model):
    gcode_command = models.CharField(max_length=100)

    def __str__(self):
        return self.gcode_command
