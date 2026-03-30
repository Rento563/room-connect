from django.db import models
import uuid


class User(models.Model):
    """User model for Rento application."""
    
    ROLE_CHOICES = [
        ('tenant', 'Tenant'),
        ('landowner', 'Landowner'),
    ]
    
    id = models.CharField(max_length=255, primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'users'
        verbose_name = 'User'
        verbose_name_plural = 'Users'
    
    def __str__(self):
        return f"{self.name} ({self.email})"
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'phone': self.phone,
            'role': self.role,
            'createdAt': self.created_at.isoformat() if self.created_at else None,
        }
