class Users {
  final int? user_id; // Nullable for auto-increment
  final String full_name;
  final String user_name;
  final String email;
  final String password_hash;
  final String avatar;
  final String role;
  final String status;

  Users({
    this.user_id,
    required this.full_name,
    required this.user_name,
    required this.email,
    required this.password_hash,
    required this.avatar,
    required this.role,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id, // Will be auto-incremented by the database
      'full_name': full_name,
      'user_name': user_name,
      'email': email,
      'password_hash': password_hash,
      'avatar': avatar,
      'role': role,
      'status': status,
    };
  }

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      user_id: map['user_id'] as int?, // Nullable
      full_name: map['full_name'] as String? ?? '', // Default to empty string
      user_name: map['user_name'] as String? ?? '', // Default to empty string
      email: map['email'] as String? ?? '', // Default to empty string
      password_hash:
          map['password_hash'] as String? ?? '', // Default to empty string
      avatar: map['avatar'] as String? ?? '', // Default to empty string
      role: map['role'] as String? ?? 'user', // Default role if null
      status: map['status'] as String? ?? 'inactive', // Default status if null
    );
  }

  @override
  String toString() {
    return 'Users(user_id: $user_id, full_name: $full_name, avatar: $avatar, user_name: $user_name, email: $email, role: $role, status: $status)';
  }
}
