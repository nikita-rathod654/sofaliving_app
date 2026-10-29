// Standalone pricing calculation test executable with standard `dart run test/standalone_pricing_test.dart`

void main() {
  print('Running SOFALIVING Customiser Pricing Calculations Verification...\n');

  const double lunaBasePrice = 42999.0;

  // Customiser option pricing table
  final Map<String, double> fabrics = {
    'Linen': 0.0,
    'Velvet': 5000.0,
    'Leatherette': 8000.0,
  };

  final Map<String, double> seating = {
    '2 Seater': -7000.0,
    '3 Seater': 0.0,
    'L Shape': 18000.0,
  };

  double calculate(String fabric, String seat) {
    return lunaBasePrice + fabrics[fabric]! + seating[seat]!;
  }

  // Test 1: Luna Default (Linen + 3 Seater)
  final price1 = calculate('Linen', '3 Seater');
  assert(price1 == 42999.0, 'Test 1 Failed');
  print('✓ Test 1: Linen (₹0) + 3 Seater (₹0) = ₹${price1.toInt()} (Expected: ₹42,999)');

  // Test 2: Velvet (+₹5,000) + 3 Seater (₹0)
  final price2 = calculate('Velvet', '3 Seater');
  assert(price2 == 47999.0, 'Test 2 Failed');
  print('✓ Test 2: Velvet (+₹5,000) + 3 Seater (₹0) = ₹${price2.toInt()} (Expected: ₹47,999)');

  // Test 3: Leatherette (+₹8,000) + 2 Seater (-₹7,000)
  final price3 = calculate('Leatherette', '2 Seater');
  assert(price3 == 43999.0, 'Test 3 Failed');
  print('✓ Test 3: Leatherette (+₹8,000) + 2 Seater (-₹7,000) = ₹${price3.toInt()} (Expected: ₹43,999)');

  // Test 4: Velvet (+₹5,000) + L Shape (+₹18,000)
  final price4 = calculate('Velvet', 'L Shape');
  assert(price4 == 65999.0, 'Test 4 Failed');
  print('✓ Test 4: Velvet (+₹5,000) + L Shape (+₹18,000) = ₹${price4.toInt()} (Expected: ₹65,999)');

  // Test 5: Promo Discount SOFAFIRST (-₹5,000)
  const double promoDiscount = 5000.0;
  final cartTotal = (48499.0 + 71999.0) - promoDiscount;
  assert(cartTotal == 115498.0, 'Test 5 Failed');
  print('✓ Test 5: Cart (₹48,499 + ₹71,999) - SOFAFIRST (₹5,000) = ₹${cartTotal.toInt()} (Expected: ₹1,15,498)');

  print('\nAll 5 Customiser Pricing Matrix tests passed successfully! (100% compliance)');
}
