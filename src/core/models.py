from django.db import models


class Job(models.Model):
    sender = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True)
