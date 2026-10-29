import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/mock_data.dart'; 

enum ProductSortOption {
  popularity,
  priceLowToHigh,
  priceHighToLow,
  topRated,
}

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

List<Product> _allProducts = List.of(MockData.products);
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  ProductSortOption _sortOption = ProductSortOption.popularity;

  // Filter Bottom Sheet Criteria
  double _minPrice = 30000;
  double _maxPrice = 120000;
  final Set<String> _selectedMaterials = {};
  final Set<String> _selectedSeating = {};

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  ProductSortOption get sortOption => _sortOption;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  Set<String> get selectedMaterials => _selectedMaterials;
  Set<String> get selectedSeating => _selectedSeating;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _allProducts = await _apiService.fetchProducts();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void toggleMaterialFilter(String material) {
    if (_selectedMaterials.contains(material)) {
      _selectedMaterials.remove(material);
    } else {
      _selectedMaterials.add(material);
    }
    notifyListeners();
  }

  void toggleSeatingFilter(String seating) {
    if (_selectedSeating.contains(seating)) {
      _selectedSeating.remove(seating);
    } else {
      _selectedSeating.add(seating);
    }
    notifyListeners();
  }

  void resetFilters() {
    _minPrice = 30000;
    _maxPrice = 120000;
    _selectedMaterials.clear();
    _selectedSeating.clear();
    notifyListeners();
  }

  // Filtered & Sorted list for Product Listing Screen
  List<Product> get filteredProducts {
    List<Product> list = List.from(_allProducts);

    // 1. Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }).toList();
    }

    // 2. Category Filter
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // 3. Price Filter
    list = list.where((p) => p.basePrice >= _minPrice && p.basePrice <= _maxPrice).toList();

    // 4. Material Provenance Filter
    if (_selectedMaterials.isNotEmpty) {
      list = list.where((p) {
        return p.fabrics.any((f) => _selectedMaterials.any((m) => f.name.toLowerCase().contains(m.toLowerCase())));
      }).toList();
    }

    // 5. Seating Filter
    if (_selectedSeating.isNotEmpty) {
      list = list.where((p) {
        return p.seatingOptions.any((s) => _selectedSeating.any((seat) => s.name.toLowerCase().contains(seat.toLowerCase())));
      }).toList();
    }

    // 6. Sorting
    switch (_sortOption) {
      case ProductSortOption.popularity:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => b.basePrice.compareTo(a.basePrice));
        break;
      case ProductSortOption.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  // Featured sofas for Home Screen
  List<Product> get featuredSofas {
    return _allProducts.take(4).toList();
  }

  Product? findById(int id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Product? findBySlug(String slug) {
    try {
      return _allProducts.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
