import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/wishlist_item.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/user.dart';
import 'mock_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Android emulator maps 10.0.2.2 to host machine's localhost
  // Windows desktop / iOS / Web use localhost
  static const String baseUrl = 'https://sofaliving-app.onrender.com/api';

  bool isConnectedToMySQL = false;
  DateTime? _lastCheck;

  Future<bool> checkConnection() async {
     if (isConnectedToMySQL &&
        _lastCheck != null &&
        DateTime.now().difference(_lastCheck!) < const Duration(minutes: 2)) {
      return true;
    }
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(milliseconds: 2000));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        isConnectedToMySQL = (data['mysql'] == 'connected');
        return isConnectedToMySQL;
      }
    } catch (_) {
      isConnectedToMySQL = false;
    }
    return false;
  }

  // --- AUTH ---
  Future<User?> login(String email, String password) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return User.fromJson(data['user']);
        }
      }
    } catch (e) {
      debugPrint('API login failed, using local mock: $e');
    }

    // Local Fallback for Demo User or Mock User
    if (email.toLowerCase().trim() == 'aarav.mehta@example.com' &&
        password == 'password123') {
      return User.demoUser();
    } else if (email.isNotEmpty && password.isNotEmpty) {
      return User(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        email: email,
        fullName: email.split('@').first,
        phone: '+91 9820123456',
      );
    }
    return null;
  }

  Future<User?> register(String email, String password, String fullName, String phone) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'full_name': fullName,
            'phone': phone,
          }),
        );
        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          return User.fromJson(data['user']);
        }
      }
    } catch (e) {
      debugPrint('API register failed, using local: $e');
    }

    return User(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      email: email,
      fullName: fullName,
      phone: phone,
    );
  }

  // --- PRODUCTS ---
  Future<List<Product>> fetchProducts() async {
    try {
      if (await checkConnection()) {
        final response = await http.get(Uri.parse('$baseUrl/products'));
        if (response.statusCode == 200) {
          final List list = json.decode(response.body);
          return list.map((item) => Product.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('API fetchProducts failed, using local mock: $e');
    }
    return MockData.products;
  }

  // --- CART ---
  Future<List<CartItem>> fetchCart(int userId) async {
    try {
      if (await checkConnection()) {
        final response = await http.get(
          Uri.parse('$baseUrl/cart'),
          headers: {'x-user-id': userId.toString()},
        );
        if (response.statusCode == 200) {
          final List list = json.decode(response.body);
          return list.map((item) => CartItem.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('API fetchCart failed: $e');
    }
    // If demo user and offline, return seeded cart
    if (userId == 1) {
      return MockData.getDemoCartItems();
    }
    return [];
  }

  Future<bool> addToCart({
    required int userId,
    required int productId,
    required String color,
    required String fabric,
    required String seating,
    required int quantity,
    required double unitPrice,
  }) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/cart'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': userId.toString(),
          },
          body: json.encode({
            'productId': productId,
            'color': color,
            'fabric': fabric,
            'seating': seating,
            'quantity': quantity,
            'unitPrice': unitPrice,
          }),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      }
    } catch (e) {
      debugPrint('API addToCart error: $e');
    }
    return true; // Local handles state if offline
  }

  Future<bool> updateCartQuantity(int cartItemId, int quantity) async {
    try {
      if (await checkConnection()) {
        final response = await http.put(
          Uri.parse('$baseUrl/cart/$cartItemId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'quantity': quantity}),
        );
        return response.statusCode == 200;
      }
    } catch (_) {}
    return true;
  }

  Future<bool> removeFromCart(int cartItemId) async {
    try {
      if (await checkConnection()) {
        final response = await http.delete(Uri.parse('$baseUrl/cart/$cartItemId'));
        return response.statusCode == 200;
      }
    } catch (_) {}
    return true;
  }

  Future<bool> clearCart(int userId) async {
    try {
      if (await checkConnection()) {
        await http.delete(
          Uri.parse('$baseUrl/cart'),
          headers: {'x-user-id': userId.toString()},
        );
      }
    } catch (_) {}
    return true;
  }

  // --- WISHLIST ---
  Future<List<WishlistItem>> fetchWishlist(int userId) async {
    try {
      if (await checkConnection()) {
        final response = await http.get(
          Uri.parse('$baseUrl/wishlist'),
          headers: {'x-user-id': userId.toString()},
        );
        if (response.statusCode == 200) {
          final List list = json.decode(response.body);
          return list.map((item) => WishlistItem.fromJson(item)).toList();
        }
      }
    } catch (e) {
      debugPrint('API fetchWishlist failed: $e');
    }
    if (userId == 1) {
      return MockData.getDemoWishlistItems();
    }
    return [];
  }

  Future<bool> toggleWishlist({
    required int userId,
    required int productId,
    required String color,
    required String fabric,
    required String seating,
    required double price,
  }) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/wishlist'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': userId.toString(),
          },
          body: json.encode({
            'productId': productId,
            'color': color,
            'fabric': fabric,
            'seating': seating,
            'price': price,
          }),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      }
    } catch (_) {}
    return true;
  }

  Future<bool> removeFromWishlist(int wishlistId) async {
    try {
      if (await checkConnection()) {
        await http.delete(Uri.parse('$baseUrl/wishlist/$wishlistId'));
      }
    } catch (_) {}
    return true;
  }

  Future<bool> clearWishlist(int userId) async {
    try {
      if (await checkConnection()) {
        await http.delete(
          Uri.parse('$baseUrl/wishlist'),
          headers: {'x-user-id': userId.toString()},
        );
      }
    } catch (_) {}
    return true;
  }

  Future<bool> moveWishlistToCart(int userId, int wishlistId) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/wishlist/move-to-cart'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': userId.toString(),
          },
          body: json.encode({'wishlistId': wishlistId}),
        );
        return response.statusCode == 200;
      }
    } catch (_) {}
    return true;
  }

  Future<bool> moveAllWishlistToCart(int userId) async {
    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/wishlist/move-all-to-cart'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': userId.toString(),
          },
        );
        return response.statusCode == 200;
      }
    } catch (_) {}
    return true;
  }

  // --- ADDRESSES ---
  Future<List<SavedAddress>> fetchAddresses(int userId) async {
    try {
      if (await checkConnection()) {
        final response = await http.get(
          Uri.parse('$baseUrl/addresses'),
          headers: {'x-user-id': userId.toString()},
        );
        if (response.statusCode == 200) {
          final List list = json.decode(response.body);
          return list.map((item) => SavedAddress.fromJson(item)).toList();
        }
      }
    } catch (_) {}
    return MockData.getDemoAddresses();
  }

  // --- ORDERS ---
  Future<OrderModel?> placeOrder({
    required int userId,
    required String recipientName,
    required String phone,
    required String email,
    required String street,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double total,
    required List<CartItem> items,
  }) async {
    final itemSnapshots = items
        .map((i) => OrderItemSnapshot(
              name: i.name,
              color: i.color,
              fabric: i.fabric,
              seating: i.seating,
              quantity: i.quantity,
              unitPrice: i.unitPrice,
              totalPrice: i.totalPrice,
              image: i.image,
            ))
        .toList();

    try {
      if (await checkConnection()) {
        final response = await http.post(
          Uri.parse('$baseUrl/orders'),
          headers: {
            'Content-Type': 'application/json',
            'x-user-id': userId.toString(),
          },
          body: json.encode({
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
            'items': itemSnapshots.map((i) => i.toJson()).toList(),
          }),
        );
        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          return OrderModel(
            id: data['orderId'],
            orderRef: data['orderRef'],
            userId: userId,
            recipientName: recipientName,
            phone: phone,
            email: email,
            street: street,
            landmark: landmark,
            city: city,
            state: state,
            pincode: pincode,
            paymentMethod: paymentMethod,
            subtotal: subtotal,
            discount: discount,
            total: total,
            status: 'Confirmed',
            items: itemSnapshots,
            createdAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      debugPrint('API placeOrder error: $e');
    }

    // Local fallback order
    final randomRef = '#SL-${100000 + (DateTime.now().millisecondsSinceEpoch % 900000)}';
    return OrderModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      orderRef: randomRef,
      userId: userId,
      recipientName: recipientName,
      phone: phone,
      email: email,
      street: street,
      landmark: landmark,
      city: city,
      state: state,
      pincode: pincode,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      discount: discount,
      total: total,
      status: 'Confirmed',
      items: itemSnapshots,
      createdAt: DateTime.now(),
    );
  }
}
