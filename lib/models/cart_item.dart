class CartItem {
  final int id;
  final int userId;
  final int productId;
  final String name;
  final String color;
  final String fabric;
  final String seating;
  int quantity;
  final double unitPrice;
  double totalPrice;
  final String image;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.color,
    required this.fabric,
    required this.seating,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final qty = json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString());
    final unit = (json['unitPrice'] is num)
        ? (json['unitPrice'] as num).toDouble()
        : (json['unit_price'] is num)
            ? (json['unit_price'] as num).toDouble()
            : double.parse(json['unitPrice'].toString());
    final total = (json['totalPrice'] is num)
        ? (json['totalPrice'] as num).toDouble()
        : (json['total_price'] is num)
            ? (json['total_price'] as num).toDouble()
            : unit * qty;

    return CartItem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['userId'] is int
          ? json['userId']
          : json['user_id'] is int
              ? json['user_id']
              : 1,
      productId: json['productId'] is int
          ? json['productId']
          : json['product_id'] is int
              ? json['product_id']
              : 1,
      name: json['name'] ?? json['product_name'] ?? 'Bespoke Sofa',
      color: json['color'] ?? 'Warm Beige',
      fabric: json['fabric'] ?? 'Belgian Linen',
      seating: json['seating'] ?? '3 Seater',
      quantity: qty,
      unitPrice: unit,
      totalPrice: total,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
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

  // Helper string for specs tag shown in Cart screen
  // e.g. "Color: Warm Beige • Fabric: Belgian Linen • Size: 3 Seater"
  String get specificationsLabel {
    return 'Color: $color • Fabric: $fabric • Size: $seating';
  }
}
