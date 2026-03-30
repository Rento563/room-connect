enum UserRole { tenant, landowner }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name, // Use role.name instead of toString()
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'] == 'tenant' ? UserRole.tenant : UserRole.landowner,
    );
  }
}
