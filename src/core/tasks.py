from celery import shared_task

from core.models import Job


@shared_task(name='core.create_job')
def create_job():
    Job.objects.create(sender='celery')
