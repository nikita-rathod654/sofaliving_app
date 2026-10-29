import 'package:flutter/material.dart';

double _toDouble(dynamic v, [double fallback = 0.0]) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

int _toInt(dynamic v, [int fallback = 0]) {
  if (v == null) return fallback;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? fallback;
}




class ProductColor {
  final String name;
  final String hex;

  ProductColor({required this.name, required this.hex});

  Color get color {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name'] ?? '',
      hex: json['hex'] ?? '#D8C4B6',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'hex': hex};
}

class ProductFabric {
  final String name;
  final double priceModifier;
  final String tag;

  ProductFabric({
    required this.name,
    required this.priceModifier,
    required this.tag,
  });

  factory ProductFabric.fromJson(Map<String, dynamic> json) {
    return ProductFabric(
      name: json['name'] ?? '',
      priceModifier: (json['priceModifier'] is num)
          ? (json['priceModifier'] as num).toDouble()
          : 0.0,
      tag: json['tag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'priceModifier': priceModifier,
        'tag': tag,
      };
}

class SeatingOption {
  final String name;
  final double priceModifier;
  final String tag;

  SeatingOption({
    required this.name,
    required this.priceModifier,
    required this.tag,
  });

  factory SeatingOption.fromJson(Map<String, dynamic> json) {
    return SeatingOption(
      name: json['name'] ?? '',
      priceModifier: (json['priceModifier'] is num)
          ? (json['priceModifier'] as num).toDouble()
          : 0.0,
      tag: json['tag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'priceModifier': priceModifier,
        'tag': tag,
      };
}

class Product {
  final int id;
  final String slug;
  final String name;
  final String subtitle;
  final String category;
  final double basePrice;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String? badge;
  final String description;
  final List<String> images;
  final List<ProductColor> colors;
  final List<ProductFabric> fabrics;
  final List<SeatingOption> seatingOptions;
  final Map<String, dynamic>? specifications;
  final Map<String, dynamic>? careInstructions;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.basePrice,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    this.badge,
    required this.description,
    required this.images,
    required this.colors,
    required this.fabrics,
    required this.seatingOptions,
    this.specifications,
    this.careInstructions,
  });

  // Calculate customized price based on selected fabric and seating
  double calculatePrice({
    required ProductFabric fabric,
    required SeatingOption seating,
  }) {
    return basePrice + fabric.priceModifier + seating.priceModifier;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic raw) {
      if (raw is List) return raw.map((e) => e.toString()).toList();
      return [];
    }

    List<ProductColor> parseColors(dynamic raw) {
      if (raw is List) {
        return raw.map((c) => ProductColor.fromJson(Map<String, dynamic>.from(c))).toList();
      }
      return [];
    }

    List<ProductFabric> parseFabrics(dynamic raw) {
      if (raw is List) {
        return raw.map((f) => ProductFabric.fromJson(Map<String, dynamic>.from(f))).toList();
      }
      return [];
    }

    List<SeatingOption> parseSeating(dynamic raw) {
      if (raw is List) {
        return raw.map((s) => SeatingOption.fromJson(Map<String, dynamic>.from(s))).toList();
      }
      return [];
    }

  
  return Product(
  id: _toInt(json['id']),
  slug: json['slug'] ?? '',
  name: json['name'] ?? '',
  subtitle: json['subtitle'] ?? '',
  category: json['category'] ?? 'Sofas',
  basePrice: _toDouble(json['base_price'] ?? json['basePrice']),
  originalPrice: (json['original_price'] ?? json['originalPrice']) == null
      ? null
      : _toDouble(json['original_price'] ?? json['originalPrice']),
  rating: _toDouble(json['rating'], 4.9),
  reviewCount: _toInt(json['review_count'] ?? json['reviewCount'], 120),
  badge: json['badge'],
  description: json['description'] ?? '',
  images: parseImages(json['images']),
  colors: parseColors(json['colors']),
  fabrics: parseFabrics(json['fabrics']),
  seatingOptions: parseSeating(json['seating_options'] ?? json['seatingOptions']),
  specifications: json['specifications'] is Map ? Map<String, dynamic>.from(json['specifications']) : null,
  careInstructions: json['care_instructions'] is Map ? Map<String, dynamic>.from(json['care_instructions']) : null,
);


    
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'base_price': basePrice,
      'original_price': originalPrice,
      'rating': rating,
      'review_count': reviewCount,
      'badge': badge,
      'description': description,
      'images': images,
      'colors': colors.map((c) => c.toJson()).toList(),
      'fabrics': fabrics.map((f) => f.toJson()).toList(),
      'seating_options': seatingOptions.map((s) => s.toJson()).toList(),
      'specifications': specifications,
      'care_instructions': careInstructions,
    };
  }
}
