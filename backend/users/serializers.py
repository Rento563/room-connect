from rest_framework import serializers
from .models import User


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model."""
    
    class Meta:
        model = User
        fields = ['id', 'name', 'email', 'phone', 'role', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def to_representation(self, instance):
        """Customize the output format to match the original API."""
        data = super().to_representation(instance)
        data['createdAt'] = instance.created_at.isoformat() if instance.created_at else None
        data.pop('created_at', None)
        data.pop('updated_at', None)
        return data
