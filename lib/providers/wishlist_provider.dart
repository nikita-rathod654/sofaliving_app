import 'package:flutter/foundation.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'cart_provider.dart';

class WishlistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<WishlistItem> _items = [];
  bool _isLoading = false;
  bool _simulateEmptyState = false; // Toggle to preview empty state

  List<WishlistItem> get items => _simulateEmptyState ? [] : _items;
  bool get isLoading => _isLoading;
  bool get simulateEmptyState => _simulateEmptyState;
  int get itemCount => items.length;
  bool get isEmpty => items.isEmpty;

  // Total value of wishlist items
  double get totalValue => items.fold(0.0, (sum, i) => sum + i.price);

  WishlistProvider() {
    loadWishlist(1);
  }

  Future<void> loadWishlist(int userId) async {
    _isLoading = true;
    notifyListeners();

    _items = await _apiService.fetchWishlist(userId);
    _isLoading = false;
    notifyListeners();
  }

  void toggleEmptyStatePreview() {
    _simulateEmptyState = !_simulateEmptyState;
    notifyListeners();
  }

  bool isProductWishlisted(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  Future<void> toggleWishlist({
    required int userId,
    required Product product,
    String color = 'Warm Beige',
    String fabric = 'Belgian Linen',
    String seating = '3 Seater',
    double? price,
  }) async {
    final existingIndex = _items.indexWhere((i) => i.productId == product.id);
    final itemPrice = price ?? product.basePrice;

    if (existingIndex >= 0) {
      final itemId = _items[existingIndex].id;
      _items.removeAt(existingIndex);
      await _apiService.removeFromWishlist(itemId);
    } else {
      final newItem = WishlistItem(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        userId: userId,
        productId: product.id,
        name: product.name,
        badge: product.badge,
        color: color,
        fabric: fabric,
        seating: seating,
        price: itemPrice,
        image: product.images.isNotEmpty ? product.images[0] : '',
      );
      _items.add(newItem);
      await _apiService.toggleWishlist(
        userId: userId,
        productId: product.id,
        color: color,
        fabric: fabric,
        seating: seating,
        price: itemPrice,
      );
    }

    notifyListeners();
  }

  Future<void> removeItem(int wishlistId) async {
    _items.removeWhere((i) => i.id == wishlistId);
    await _apiService.removeFromWishlist(wishlistId);
    notifyListeners();
  }

  Future<void> clearWishlist(int userId) async {
    _items.clear();
    await _apiService.clearWishlist(userId);
    notifyListeners();
  }

  Future<void> moveToCart(CartProvider cartProvider, int userId, WishlistItem item, Product? product) async {
    if (product != null) {
      await cartProvider.addItem(
        userId: userId,
        product: product,
        color: item.color,
        fabric: item.fabric,
        seating: item.seating,
        quantity: 1,
        unitPrice: item.price,
      );
    }
    await removeItem(item.id);
  }

  Future<void> moveAllToCart(CartProvider cartProvider, int userId, List<Product> allProducts) async {
    final itemsToMove = List<WishlistItem>.from(_items);
    for (final item in itemsToMove) {
      final product = allProducts.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => allProducts.first,
      );
      await cartProvider.addItem(
        userId: userId,
        product: product,
        color: item.color,
        fabric: item.fabric,
        seating: item.seating,
        quantity: 1,
        unitPrice: item.price,
      );
    }
    await clearWishlist(userId);
  }
}
