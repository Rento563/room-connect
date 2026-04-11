import 'dart:convert';
import 'package:http/http.dart' as http;

/// Django API Helper - Connects to Django backend which uses Supabase as database
class DjangoApi {
  // Django server URL (running on port 8000)
  // Use 127.0.0.1 for local, or your IP for simulator
  static String get baseUrl => 'http://127.0.0.1:8000';
  
  // ============ USER API ============
  
  /// Register user
  static Future<Map<String, dynamic>> registerUser(String name, String email, String phone, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );
    return json.decode(response.body);
  }
  
  /// Register user (alt)
  static Future<Map<String, dynamic>> registerUserWithData(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    return json.decode(response.body);
  }
  
  /// Get user by ID
  static Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));
    return json.decode(response.body);
  }
  
  /// Update user
  static Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$userId/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return json.decode(response.body);
  }
  
  // ============ ROOM API ============
  
  /// Get all rooms
  static Future<List<Map<String, dynamic>>> getAllRooms() async {
    final response = await http.get(Uri.parse('$baseUrl/api/rooms/'));
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Map<String, dynamic>.from(item)).toList();
  }
  
  /// Get room by ID
  static Future<Map<String, dynamic>> getRoom(String roomId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/rooms/$roomId'));
    return json.decode(response.body);
  }
  
  /// Get rooms by owner
  static Future<List<Map<String, dynamic>>> getRoomsByOwner(String ownerId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/rooms/owner/$ownerId'));
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Map<String, dynamic>.from(item)).toList();
  }
  
  /// Create room
  static Future<Map<String, dynamic>> createRoom(Map<String, dynamic> roomData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/rooms/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(roomData),
    );
    return json.decode(response.body);
  }
  
  /// Update room
  static Future<Map<String, dynamic>> updateRoom(String roomId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/rooms/$roomId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return json.decode(response.body);
  }
  
  /// Delete room
  static Future<void> deleteRoom(String roomId) async {
    await http.delete(Uri.parse('$baseUrl/api/rooms/$roomId'));
  }
  
  // ============ HEALTH CHECK ============
  
  /// Check if Django server is running
  static Future<bool> checkServer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}