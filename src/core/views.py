from django.shortcuts import redirect, render
from django.views.decorators.http import require_POST

from core.models import Job


def index(request):
    jobs = Job.objects.order_by('-timestamp')[:25]

    return render(request, 'core/index.html', {'jobs': jobs})


@require_POST
def create(request):
    Job.objects.create(sender='user')

    return redirect('core:index')
