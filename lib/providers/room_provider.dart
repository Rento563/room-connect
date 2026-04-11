import 'package:flutter/material.dart';
import '../models/room.dart';
import '../utils/django_api.dart';

class RoomProvider with ChangeNotifier {
  List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  Future<void> loadRooms() async {
    try {
      final response = await DjangoApi.getAllRooms();
      _rooms = response.map((json) => Room.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Load rooms error: $e');
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await DjangoApi.createRoom(room.toJson());
      _rooms.add(room);
      notifyListeners();
    } catch (e) {
      print('Add room error: $e');
    }
  }

  Future<void> updateRoom(Room updatedRoom) async {
    try {
      await DjangoApi.updateRoom(updatedRoom.id, updatedRoom.toJson());
      final index = _rooms.indexWhere((r) => r.id == updatedRoom.id);
      if (index != -1) {
        _rooms[index] = updatedRoom;
        notifyListeners();
      }
    } catch (e) {
      print('Update room error: $e');
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await DjangoApi.deleteRoom(roomId);
      _rooms.removeWhere((r) => r.id == roomId);
      notifyListeners();
    } catch (e) {
      print('Delete room error: $e');
    }
  }

  List<Room> getRoomsByOwner(String ownerId) {
    return _rooms.where((r) => r.ownerId == ownerId).toList();
  }
}
