from django.db import models
import uuid


class Room(models.Model):
    """Room model for Rento application."""
    
    ROOM_TYPE_CHOICES = [
        ('single', 'Single Room'),
        ('double', 'Double Room'),
        ('shared', 'Shared Room'),
        ('apartment', 'Apartment'),
    ]
    
    id = models.CharField(max_length=255, primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    location = models.CharField(max_length=255)
    images = models.JSONField(default=list, blank=True)
    room_type = models.CharField(max_length=20, choices=ROOM_TYPE_CHOICES, blank=True, null=True)
    owner_id = models.CharField(max_length=255)
    amenities = models.JSONField(default=list, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'app_rooms'
        verbose_name = 'Room'
        verbose_name_plural = 'Rooms'
    
    def __str__(self):
        return self.title
    
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'price': str(self.price),
            'location': self.location,
            'images': self.images,
            'roomType': self.room_type,
            'ownerId': self.owner_id,
            'amenities': self.amenities,
            'createdAt': self.created_at.isoformat() if self.created_at else None,
        }
