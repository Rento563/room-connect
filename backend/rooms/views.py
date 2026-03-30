from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Room
from .serializers import RoomSerializer


@api_view(['GET'])
def get_all_rooms(request):
    """Get all rooms."""
    rooms = Room.objects.all()
    serializer = RoomSerializer(rooms, many=True)
    return Response(serializer.data)


@api_view(['POST'])
def create_room(request):
    """Create a new room."""
    # Convert camelCase to snake_case for processing
    data = request.data.copy()
    
    # Map camelCase fields to snake_case
    if 'ownerId' in data and 'owner_id' not in data:
        data['owner_id'] = data.pop('ownerId')
    if 'roomType' in data and 'room_type' not in data:
        data['room_type'] = data.pop('roomType')
    
    required_fields = ['id', 'title', 'price', 'location', 'owner_id']
    
    # Check for required fields
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return Response(
            {'error': f'Missing required fields: {", ".join(missing_fields)}'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Check if room already exists
    room_id = data.get('id')
    if Room.objects.filter(id=room_id).exists():
        return Response(
            {'error': 'Room with this ID already exists'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    serializer = RoomSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'message': 'Room created successfully',
            'room': serializer.data
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_room(request, room_id):
    """Get specific room by ID."""
    try:
        room = Room.objects.get(id=room_id)
        serializer = RoomSerializer(room)
        return Response(serializer.data)
    except Room.DoesNotExist:
        return Response(
            {'error': 'Room not found'},
            status=status.HTTP_404_NOT_FOUND
        )


@api_view(['PUT'])
def update_room(request, room_id):
    """Update a room."""
    try:
        room = Room.objects.get(id=room_id)
    except Room.DoesNotExist:
        return Response(
            {'error': 'Room not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    
    serializer = RoomSerializer(room, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'message': 'Room updated successfully',
            'room': serializer.data
        })
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
def delete_room(request, room_id):
    """Delete a room."""
    try:
        room = Room.objects.get(id=room_id)
        room.delete()
        return Response({'message': 'Room deleted successfully'})
    except Room.DoesNotExist:
        return Response(
            {'error': 'Room not found'},
            status=status.HTTP_404_NOT_FOUND
        )


@api_view(['GET'])
def get_rooms_by_owner(request, owner_id):
    """Get all rooms by owner ID."""
    rooms = Room.objects.filter(owner_id=owner_id)
    serializer = RoomSerializer(rooms, many=True)
    return Response(serializer.data)
