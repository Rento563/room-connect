from rest_framework import serializers
from .models import Room


class RoomSerializer(serializers.ModelSerializer):
    """Serializer for Room model."""
    
    class Meta:
        model = Room
        fields = ['id', 'title', 'description', 'price', 'location', 'images', 
                  'room_type', 'owner_id', 'amenities', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def to_representation(self, instance):
        """Customize the output format to match the original API."""
        data = super().to_representation(instance)
        data['createdAt'] = instance.created_at.isoformat() if instance.created_at else None
        data['roomType'] = data.pop('room_type', None)
        data['ownerId'] = data.pop('owner_id', None)
        data.pop('created_at', None)
        data.pop('updated_at', None)
        return data
