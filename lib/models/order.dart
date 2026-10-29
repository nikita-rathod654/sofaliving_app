class OrderItemSnapshot {
  final String name;
  final String color;
  final String fabric;
  final String seating;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String image;

  OrderItemSnapshot({
    required this.name,
    required this.color,
    required this.fabric,
    required this.seating,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.image,
  });

  factory OrderItemSnapshot.fromJson(Map<String, dynamic> json) {
    return OrderItemSnapshot(
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      fabric: json['fabric'] ?? '',
      seating: json['seating'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] is num)
          ? (json['unitPrice'] as num).toDouble()
          : double.parse(json['unitPrice'].toString()),
      totalPrice: (json['totalPrice'] is num)
          ? (json['totalPrice'] as num).toDouble()
          : double.parse(json['totalPrice'].toString()),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color,
        'fabric': fabric,
        'seating': seating,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
        'image': image,
      };
}

class OrderModel {
  final int id;
  final String orderRef; // e.g. "#SL-892401"
  final int userId;
  final String recipientName;
  final String phone;
  final String email;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double total;
  final String status;
  final List<OrderItemSnapshot> items;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderRef,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.email,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItemSnapshot> parseItems(dynamic raw) {
      if (raw is List) {
        return raw.map((i) => OrderItemSnapshot.fromJson(Map<String, dynamic>.from(i))).toList();
      }
      return [];
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      orderRef: json['order_ref'] ?? json['orderRef'] ?? '#SL-892401',
      userId: json['user_id'] ?? json['userId'] ?? 1,
      recipientName: json['recipient_name'] ?? json['recipientName'] ?? 'Aarav Mehta',
      phone: json['phone'] ?? '+91 9820123456',
      email: json['email'] ?? 'aarav.mehta@example.com',
      street: json['street'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? 'Mumbai',
      state: json['state'] ?? 'Maharashtra',
      pincode: json['pincode'] ?? '400050',
      paymentMethod: json['payment_method'] ?? json['paymentMethod'] ?? 'Mock UPI / Net Banking',
      subtotal: (json['subtotal'] is num) ? (json['subtotal'] as num).toDouble() : 0.0,
      discount: (json['discount'] is num) ? (json['discount'] as num).toDouble() : 0.0,
      total: (json['total'] is num) ? (json['total'] as num).toDouble() : 0.0,
      status: json['status'] ?? 'Confirmed',
      items: parseItems(json['items']),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_ref': orderRef,
      'user_id': userId,
      'recipient_name': recipientName,
      'phone': phone,
      'email': email,
      'street': street,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'payment_method': paymentMethod,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'status': status,
      'items': items.map((i) => i.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
