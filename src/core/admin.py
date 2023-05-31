from django.contrib import admin

from core.models import Job


@admin.register(Job)
class JobAdmin(admin.ModelAdmin):
    list_display = ('id', 'sender', 'timestamp')
    ordering = ('-timestamp',)
