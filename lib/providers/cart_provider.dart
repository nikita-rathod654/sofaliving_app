import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _appliedCoupon = 'SOFAFIRST'; // Pre-applied in demo screenshot
  double _discount = 5000.0; // ₹5,000 discount for SOFAFIRST

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get appliedCoupon => _appliedCoupon;
  double get discount => _discount;

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  // Pricing calculations
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Free delivery for orders over ₹50,000
  double get whiteGloveDeliveryFee => (subtotal >= 50000 || subtotal == 0) ? 0.0 : 2999.0;

  double get estimatedTotal {
    if (subtotal == 0) return 0.0;
    final total = subtotal + whiteGloveDeliveryFee - _discount;
    return total < 0 ? 0.0 : total;
  }

  CartProvider() {
    loadCart(1); // Load default user cart
  }

  Future<void> loadCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    _items = await _apiService.fetchCart(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem({
    required int userId,
    required Product product,
    required String color,
    required String fabric,
    required String seating,
    required int quantity,
    required double unitPrice,
  }) async {
    // Check if matching item exists
    final index = _items.indexWhere(
      (item) =>
          item.productId == product.id &&
          item.color == color &&
          item.fabric == fabric &&
          item.seating == seating,
    );

    if (index >= 0) {
      _items[index].quantity += quantity;
      _items[index].totalPrice = _items[index].unitPrice * _items[index].quantity;
      await _apiService.updateCartQuantity(_items[index].id, _items[index].quantity);
    } else {
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        userId: userId,
        productId: product.id,
        name: product.name,
        color: color,
        fabric: fabric,
        seating: seating,
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: unitPrice * quantity,
        image: product.images.isNotEmpty ? product.images[0] : '',
      );
      _items.add(newItem);
      await _apiService.addToCart(
        userId: userId,
        productId: product.id,
        color: color,
        fabric: fabric,
        seating: seating,
        quantity: quantity,
        unitPrice: unitPrice,
      );
    }

    notifyListeners();
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        await removeItem(itemId);
      } else {
        _items[index].quantity = quantity;
        _items[index].totalPrice = _items[index].unitPrice * quantity;
        await _apiService.updateCartQuantity(itemId, quantity);
        notifyListeners();
      }
    }
  }

  Future<void> removeItem(int itemId) async {
    _items.removeWhere((i) => i.id == itemId);
    await _apiService.removeFromCart(itemId);
    notifyListeners();
  }

  Future<void> clearCart(int userId) async {
    _items.clear();
    await _apiService.clearCart(userId);
    notifyListeners();
  }

  bool applyCoupon(String code) {
    if (code.trim().toUpperCase() == 'SOFAFIRST') {
      _appliedCoupon = 'SOFAFIRST';
      _discount = 5000.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discount = 0.0;
    notifyListeners();
  }
}
