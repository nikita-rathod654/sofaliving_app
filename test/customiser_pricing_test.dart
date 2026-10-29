import 'package:flutter_test/flutter_test.dart';
import 'package:sofaliving_app/models/product.dart';

void main() {
  group('SOFALIVING Customiser Pricing Calculations', () {
    late Product testSofa;

    setUp(() {
      testSofa = Product(
        id: 1,
        slug: 'luna-bespoke-sofa',
        name: 'Luna Bespoke Sofa',
        subtitle: 'Sculptural silhouette',
        category: 'Sofas',
        basePrice: 42999.0,
        rating: 4.9,
        reviewCount: 142,
        description: 'Test sofa description',
        images: ['https://example.com/sofa.jpg'],
        colors: [
          ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
        ],
        fabrics: [
          ProductFabric(name: 'Belgian Linen', priceModifier: 0, tag: 'Included'),
          ProductFabric(name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000'),
          ProductFabric(name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000'),
        ],
        seatingOptions: [
          SeatingOption(name: '2 Seater (Ease)', priceModifier: -7000, tag: '−₹7,000'),
          SeatingOption(name: '3 Seater (Standard)', priceModifier: 0, tag: 'Included'),
          SeatingOption(name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000'),
        ],
      );
    });

    test('Default 3 Seater with Linen should equal Luna base price ₹42,999', () {
      final fabric = testSofa.fabrics[0]; // Linen: +0
      final seating = testSofa.seatingOptions[1]; // 3 Seater: +0
      final price = testSofa.calculatePrice(fabric: fabric, seating: seating);
      expect(price, 42999.0);
    });

    test('Velvet fabric should add +₹5,000', () {
      final fabric = testSofa.fabrics[1]; // Velvet: +5000
      final seating = testSofa.seatingOptions[1]; // 3 Seater: +0
      final price = testSofa.calculatePrice(fabric: fabric, seating: seating);
      expect(price, 47999.0);
    });

    test('2 Seater with Leatherette should calculate ₹42,999 + 8,000 - 7,000 = ₹43,999', () {
      final fabric = testSofa.fabrics[2]; // Leatherette: +8000
      final seating = testSofa.seatingOptions[0]; // 2 Seater: -7000
      final price = testSofa.calculatePrice(fabric: fabric, seating: seating);
      expect(price, 43999.0);
    });

    test('L Shape with Velvet should calculate ₹42,999 + 5,000 + 18,000 = ₹65,999', () {
      final fabric = testSofa.fabrics[1]; // Velvet: +5000
      final seating = testSofa.seatingOptions[2]; // L Shape: +18000
      final price = testSofa.calculatePrice(fabric: fabric, seating: seating);
      expect(price, 65999.0);
    });
  });
}
