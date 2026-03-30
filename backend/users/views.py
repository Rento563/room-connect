from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import User
from .serializers import UserSerializer
import uuid


@api_view(['POST'])
def register_user(request):
    """Register a new user."""
    required_fields = ['id', 'name', 'email', 'phone', 'role']
    
    # Check for required fields
    missing_fields = [field for field in required_fields if not request.data.get(field)]
    if missing_fields:
        return Response(
            {'error': f'Missing required fields: {", ".join(missing_fields)}'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Validate role
    valid_roles = ['tenant', 'landowner']
    if request.data.get('role') not in valid_roles:
        return Response(
            {'error': f'Role must be one of: {", ".join(valid_roles)}'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Check if user already exists
    user_id = request.data.get('id')
    if User.objects.filter(id=user_id).exists():
        return Response(
            {'error': 'User with this ID already exists'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'message': 'User registered successfully',
            'user': serializer.data
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_user(request, user_id):
    """Get user profile by ID."""
    try:
        user = User.objects.get(id=user_id)
        serializer = UserSerializer(user)
        return Response(serializer.data)
    except User.DoesNotExist:
        return Response(
            {'error': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )


@api_view(['PUT'])
def update_user(request, user_id):
    """Update user profile."""
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response(
            {'error': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    
    serializer = UserSerializer(user, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'message': 'User updated successfully',
            'user': serializer.data
        })
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
