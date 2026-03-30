from django.urls import path
from . import views

urlpatterns = [
    path('register', views.register_user, name='register_user'),
    path('<str:user_id>', views.get_user, name='get_user'),
    path('<str:user_id>/update', views.update_user, name='update_user'),
]
