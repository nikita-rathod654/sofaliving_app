class SavedAddress {
  final int id;
  final int userId;
  final String label; // "Home", "Office - BKC", etc.
  final String recipientName;
  final String phone;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  SavedAddress({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : json['userId'] is int
              ? json['userId']
              : 1,
      label: json['label'] ?? 'Home',
      recipientName: json['recipient_name'] ?? json['recipientName'] ?? 'Aarav Mehta',
      phone: json['phone'] ?? '+91 9820123456',
      street: json['street'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? 'Mumbai',
      state: json['state'] ?? 'Maharashtra',
      pincode: json['pincode'] ?? '400050',
      isDefault: json['is_default'] == 1 || json['is_default'] == true || json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'street': street,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_default': isDefault,
    };
  }

  String get fullAddressLine {
    final parts = [street, if (landmark.isNotEmpty) landmark, city, '$state - $pincode'];
    return parts.join(', ');
  }
}
