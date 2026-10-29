import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/wishlist_item.dart';
import '../models/address.dart';

class MockData {
  static final List<Product> products = [
    Product(
      id: 1,
      slug: 'luna-bespoke-sofa',
      name: 'Luna Bespoke Sofa',
      subtitle: 'Sculptural silhouette meets cloud-soft ergonomics',
      category: 'Sofas',
      basePrice: 42999.0,
      originalPrice: 54999.0,
      rating: 4.9,
      reviewCount: 142,
      badge: 'Bespoke Craft',
      description:
          'Sculptural silhouette meets cloud-soft ergonomics. Hand-crafted solid teak frame paired with high-resilience foam and customizable Belgian upholstery.',
      images: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
        ProductColor(name: 'Forest Emerald', hex: '#2D4B3E'),
        ProductColor(name: 'Slate Teal', hex: '#415A63'),
        ProductColor(name: 'Charcoal Night', hex: '#2B2B2B'),
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
      specifications: {
        'Dimensions': 'W 220cm x D 98cm x H 78cm',
        'Seat Height': '44cm',
        'Frame': 'FSC-Certified Solid Teak Frame',
        'Cushion Fill': 'Multi-layer High Resilience Foam + Goose Down Blend',
        'Origin': 'Atelier Handcrafted in India',
      },
      careInstructions: {
        'Professional Care': 'Professional dry clean recommended for Belgian linen.',
        'Routine': 'Vacuum regularly with a soft upholstery brush attachment.',
        'Sunlight': 'Keep away from direct prolonged midday sun exposure.',
      },
    ),
    Product(
      id: 2,
      slug: 'kanso-sectional',
      name: 'Kanso Sectional',
      subtitle: 'Sand Linen · L-Shape Modular System',
      category: 'Sectionals',
      basePrice: 64500.0,
      originalPrice: 72000.0,
      rating: 4.9,
      reviewCount: 88,
      badge: 'Bespoke',
      description:
          'Brushed Taupe Linen Kanso Sectional. Deep proportions with a low Japanese-inspired floating wood base and plush feather-blend cushions.',
      images: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Slate Grey', hex: '#5A5F63'),
        ProductColor(name: 'Sand Taupe', hex: '#C2B6A6'),
        ProductColor(name: 'Oatmeal Bouclé', hex: '#E6E1DA'),
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
      specifications: {
        'Dimensions': 'W 280cm x D 165cm x H 75cm',
        'Seat Height': '42cm',
        'Frame': 'Kiln-dried White Oak',
        'Fill': 'High Density Pocket Coils & Down Wrap',
      },
      careInstructions: {
        'Spot Cleaning': 'Spot clean with mild water-free solvent.',
        'Fluffing': 'Fluff cushions weekly for optimal loft.',
      },
    ),
    Product(
      id: 3,
      slug: 'oslo-modular',
      name: 'Oslo Modular',
      subtitle: 'Flexible 3-piece layout engineered with cloud-soft comfort',
      category: 'Modular',
      basePrice: 52000.0,
      originalPrice: 59000.0,
      rating: 4.9,
      reviewCount: 94,
      badge: 'Modular Config',
      description:
          'Flexible 3-piece layout engineered with cloud-soft comfort and high-density pocket cores for endlessly adaptable living rooms.',
      images: [
        'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
        ProductColor(name: 'Charcoal Night', hex: '#2B2B2B'),
        ProductColor(name: 'Forest Emerald', hex: '#2D4B3E'),
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
      specifications: {
        'Dimensions': 'W 240cm x D 105cm x H 76cm',
        'Seat Height': '43cm',
        'Frame': 'Solid Ash Wood Frame',
      },
    ),
    Product(
      id: 4,
      slug: 'haven-velvet-accent-chair',
      name: 'Haven Velvet Accent Chair',
      subtitle: 'Olive Green · Single Armchair · Matte Velvet',
      category: 'Armchairs',
      basePrice: 24999.0,
      originalPrice: 29999.0,
      rating: 4.8,
      reviewCount: 63,
      badge: 'Restock',
      description:
          'Explore hand-stitched curved silhouettes and rich Japanese cedar framework tailored for mindful living.',
      images: [
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Forest Emerald', hex: '#2D4B3E'),
        ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
        ProductColor(name: 'Slate Teal', hex: '#415A63'),
      ],
      fabrics: [
        ProductFabric(name: 'Belgian Linen', priceModifier: 0, tag: 'Included'),
        ProductFabric(name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000'),
      ],
      seatingOptions: [
        SeatingOption(name: 'Single Accent', priceModifier: 0, tag: 'Standard'),
      ],
    ),
    Product(
      id: 5,
      slug: 'aura-curved-chaise',
      name: 'Aura Curved Chaise Lounge',
      subtitle: 'Organic sculpted curves crafted with Italian bouclé',
      category: 'Sofas',
      basePrice: 58000.0,
      originalPrice: 66000.0,
      rating: 4.9,
      reviewCount: 41,
      badge: 'Artisan Workshop',
      description:
          'Sensual curved lines meet relaxed architectural posture. Perfect for spacious open floor living rooms.',
      images: [
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
        ProductColor(name: 'Slate Teal', hex: '#415A63'),
      ],
      fabrics: [
        ProductFabric(name: 'Belgian Linen', priceModifier: 0, tag: 'Included'),
        ProductFabric(name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000'),
      ],
      seatingOptions: [
        SeatingOption(name: '3 Seater Curved', priceModifier: 0, tag: 'Standard'),
        SeatingOption(name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000'),
      ],
    ),
    Product(
      id: 6,
      slug: 'kyoto-low-profile-recliner',
      name: 'Kyoto Low-Profile Recliner',
      subtitle: 'Silent German-engineered mechanical reclining glider',
      category: 'Recliners',
      basePrice: 39500.0,
      originalPrice: 45000.0,
      rating: 4.7,
      reviewCount: 76,
      badge: 'Minimalist',
      description:
          'Concealed power recline function maintains clean architectural silhouettes without compromising ergonomic support.',
      images: [
        'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
      ],
      colors: [
        ProductColor(name: 'Charcoal Night', hex: '#2B2B2B'),
        ProductColor(name: 'Warm Beige', hex: '#D8C4B6'),
      ],
      fabrics: [
        ProductFabric(name: 'Belgian Linen', priceModifier: 0, tag: 'Included'),
        ProductFabric(name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000'),
      ],
      seatingOptions: [
        SeatingOption(name: 'Single Recliner', priceModifier: 0, tag: 'Standard'),
      ],
    ),
  ];

  static List<CartItem> getDemoCartItems() {
    return [
      CartItem(
        id: 101,
        userId: 1,
        productId: 1,
        name: 'Luna Sofa',
        color: 'Warm Beige',
        fabric: 'Belgian Linen',
        seating: '3 Seater',
        quantity: 1,
        unitPrice: 48499.0,
        totalPrice: 48499.0,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ),
      CartItem(
        id: 102,
        userId: 1,
        productId: 2,
        name: 'Kanso Sectional',
        color: 'Slate Grey',
        fabric: 'Velvet',
        seating: 'L Shape',
        quantity: 1,
        unitPrice: 71999.0,
        totalPrice: 71999.0,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }

  static List<WishlistItem> getDemoWishlistItems() {
    return [
      WishlistItem(
        id: 201,
        userId: 1,
        productId: 1,
        name: 'Luna Sofa',
        badge: 'RESTOCK',
        color: 'Warm Beige',
        fabric: 'Belgian Fabric',
        seating: 'Custom 3 Seater',
        price: 48499.0,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ),
      WishlistItem(
        id: 202,
        userId: 1,
        productId: 2,
        name: 'Kanso Sectional',
        badge: 'Modern Order',
        color: 'Sand Linen',
        fabric: 'Belgian Fabric',
        seating: 'L-Shape Modular',
        price: 68499.0,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      ),
      WishlistItem(
        id: 203,
        userId: 1,
        productId: 4,
        name: 'Haven Velvet Accent Chair',
        badge: 'RESTOCK',
        color: 'Olive Green',
        fabric: 'Matte Velvet',
        seating: 'Single Armchair',
        price: 24999.0,
        image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }

  static List<SavedAddress> getDemoAddresses() {
    return [
      SavedAddress(
        id: 1,
        userId: 1,
        label: 'Home',
        recipientName: 'Aarav Mehta',
        phone: '+91 9820123456',
        street: '402, Lotus Grandeur, 14th Road',
        landmark: 'Near Joggers Park, Bandra West',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400050',
        isDefault: true,
      ),
      SavedAddress(
        id: 2,
        userId: 1,
        label: 'Office - BKC',
        recipientName: 'Aarav Mehta',
        phone: '+91 9820123456',
        street: 'G Block, Bandra Kurla Complex',
        landmark: 'Near Diamond Bourse',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400051',
        isDefault: false,
      ),
    ];
  }
}
