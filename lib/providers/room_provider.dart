import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';

class RoomProvider with ChangeNotifier {
  List<Room> _rooms = [];
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Room> get rooms => _rooms;

  Future<void> loadRooms() async {
    try {
      final response = await _supabase.from('rooms').select();
      _rooms = response.map((json) => Room.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Load rooms error: $e');
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await _supabase.from('rooms').insert(room.toJson());
      _rooms.add(room);
      notifyListeners();
    } catch (e) {
      print('Add room error: $e');
    }
  }

  Future<void> updateRoom(Room updatedRoom) async {
    try {
      await _supabase
          .from('rooms')
          .update(updatedRoom.toJson())
          .eq('id', updatedRoom.id);
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
      await _supabase.from('rooms').delete().eq('id', roomId);
      _rooms.removeWhere((r) => r.id == roomId);
      notifyListeners();
    } catch (e) {
      print('Delete room error: $e');
    }
  }

  List<Room> getRoomsByOwner(String ownerId) {
    return _rooms.where((r) => r.ownerId == ownerId).toList();
  }

  // Keep local save for offline support if needed
  Future<void> _saveRoomsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsJson = _rooms.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('rooms', roomsJson);
  }
}
