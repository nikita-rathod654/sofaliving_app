class User {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      phone: json['phone'] ?? '+91 9820123456',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
    };
  }

  // Pre-configured Demo User Aarav Mehta
  static User demoUser() {
    return User(
      id: 1,
      email: 'aarav.mehta@example.com',
      fullName: 'Aarav Mehta',
      phone: '+91 9820123456',
    );
  }
}
