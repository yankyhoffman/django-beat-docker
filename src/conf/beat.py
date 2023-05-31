from celery.schedules import crontab

SCHEDULES = {
    'core.create_job': {
        'task': 'core.create_job',
        'schedule': crontab(minute='*/5'),
    }
}
