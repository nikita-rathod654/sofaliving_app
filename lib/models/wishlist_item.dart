class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final String name;
  final String? badge;
  final String color;
  final String fabric;
  final String seating;
  final double price;
  final String image;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.name,
    this.badge,
    required this.color,
    required this.fabric,
    required this.seating,
    required this.price,
    required this.image,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
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
      name: json['name'] ?? json['product_name'] ?? 'Bespoke Piece',
      badge: json['badge'] ?? json['product_badge'],
      color: json['color'] ?? 'Warm Beige',
      fabric: json['fabric'] ?? 'Belgian Linen',
      seating: json['seating'] ?? '3 Seater',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.parse(json['price'].toString()),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'name': name,
      'badge': badge,
      'color': color,
      'fabric': fabric,
      'seating': seating,
      'price': price,
      'image': image,
    };
  }

  // Summary label e.g. "Custom 3 Seater • Warm Beige • Belgian Fabric"
  String get summaryLabel {
    return '$seating • $color • $fabric';
  }
}
