from django.urls import path
from . import views

urlpatterns = [
    path('', views.get_all_rooms, name='get_all_rooms'),
    path('create', views.create_room, name='create_room'),
    path('<str:room_id>', views.get_room, name='get_room'),
    path('owner/<str:owner_id>', views.get_rooms_by_owner, name='get_rooms_by_owner'),
]
