import 'package:flutter/foundation.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';

enum PaymentMethod {
  upi,
  card,
  cod,
}

class CheckoutProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<SavedAddress> _savedAddresses = [];
  SavedAddress? _selectedAddress;
  bool _isLoading = false;

  // Contact form fields
  String _fullName = 'Aarav Mehta';
  String _phone = '9820123456';
  String _email = 'aarav.mehta@example.com';

  // Address form fields
  String _street = '402, Lotus Grandeur, 14th Road';
  String _landmark = 'Near Joggers Park, Bandra West';
  String _city = 'Mumbai';
  String _state = 'Maharashtra';
  String _pincode = '400050';

  PaymentMethod _selectedPayment = PaymentMethod.upi;
  OrderModel? _lastPlacedOrder;

  List<SavedAddress> get savedAddresses => _savedAddresses;
  SavedAddress? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;

  String get fullName => _fullName;
  String get phone => _phone;
  String get email => _email;
  String get street => _street;
  String get landmark => _landmark;
  String get city => _city;
  String get state => _state;
  String get pincode => _pincode;
  PaymentMethod get selectedPayment => _selectedPayment;
  OrderModel? get lastPlacedOrder => _lastPlacedOrder;

  // White Glove delivery eligibility (valid 6-digit PIN code)
  bool get isEligibleForWhiteGlove => _pincode.trim().length == 6;

  String get paymentMethodTitle {
    switch (_selectedPayment) {
      case PaymentMethod.upi:
        return 'Mock UPI / Net Banking';
      case PaymentMethod.card:
        return 'Mock Credit/Debit Card';
      case PaymentMethod.cod:
        return 'Pay on Delivery (Demo)';
    }
  }

  CheckoutProvider() {
    loadSavedAddresses(1);
  }

  Future<void> loadSavedAddresses(int userId) async {
    _isLoading = true;
    notifyListeners();

    _savedAddresses = await _apiService.fetchAddresses(userId);
    if (_savedAddresses.isNotEmpty) {
      selectSavedAddress(_savedAddresses.first);
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectSavedAddress(SavedAddress addr) {
    _selectedAddress = addr;
    _street = addr.street;
    _landmark = addr.landmark;
    _city = addr.city;
    _state = addr.state;
    _pincode = addr.pincode;
    _fullName = addr.recipientName;
    _phone = addr.phone.replaceAll('+91 ', '');
    notifyListeners();
  }

  void updateContactInfo({String? name, String? phone, String? email}) {
    if (name != null) _fullName = name;
    if (phone != null) _phone = phone;
    if (email != null) _email = email;
    notifyListeners();
  }

  void updateAddressInfo({
    String? street,
    String? landmark,
    String? city,
    String? state,
    String? pincode,
  }) {
    if (street != null) _street = street;
    if (landmark != null) _landmark = landmark;
    if (city != null) _city = city;
    if (state != null) _state = state;
    if (pincode != null) _pincode = pincode;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethod method) {
    _selectedPayment = method;
    notifyListeners();
  }

  bool validateCheckoutForm() {
    if (_fullName.trim().isEmpty) return false;
    if (_phone.trim().isEmpty || _phone.trim().length < 8) return false;
    if (_email.trim().isEmpty || !_email.contains('@')) return false;
    if (_street.trim().isEmpty) return false;
    if (_city.trim().isEmpty) return false;
    if (_state.trim().isEmpty) return false;
    if (_pincode.trim().length != 6) return false;
    return true;
  }

  Future<OrderModel?> placeDemoOrder({
    required int userId,
    required double subtotal,
    required double discount,
    required double total,
    required List<CartItem> items,
  }) async {
    _isLoading = true;
    notifyListeners();

    final order = await _apiService.placeOrder(
      userId: userId,
      recipientName: _fullName,
      phone: '+91 $_phone',
      email: _email,
      street: _street,
      landmark: _landmark,
      city: _city,
      state: _state,
      pincode: _pincode,
      paymentMethod: paymentMethodTitle,
      subtotal: subtotal,
      discount: discount,
      total: total,
      items: items,
    );

    _lastPlacedOrder = order;
    _isLoading = false;
    notifyListeners();
    return order;
  }
}
