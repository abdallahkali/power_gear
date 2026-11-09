import 'package:flutter/foundation.dart';
import '../data/store_repository.dart';
import '../models/product.dart';

enum SortBy { popular, newest, priceLow, priceHigh, rating }

class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repo);
  final StoreRepository _repo;

  List<Product> products = [];
  List<ProductCategory> categories = [];
  bool loading = false;
  String? error;

  String query = '';
  String? categoryId;
  SortBy sort = SortBy.popular;
  int priceMin = 0;
  int? priceMax;
  bool onlyOffers = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      categories = await _repo.getCategories();
      products = await _repo.getProducts();
    } catch (_) {
      error = 'load';
    }
    loading = false;
    notifyListeners();
  }

  Product? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  int get maxPrice {
    if (products.isEmpty) return 1000;
    var m = 0;
    for (final p in products) {
      if (p.price > m) m = p.price;
    }
    return ((m / 100).ceil()) * 100;
  }

  int get activeFilters =>
      (categoryId != null ? 1 : 0) +
      (priceMin > 0 || priceMax != null ? 1 : 0) +
      (onlyOffers ? 1 : 0);

  List<Product> get bestSellers => products.where((p) => p.bestSeller).toList();
  List<Product> get newArrivals => products.where((p) => p.isNew).toList();
  List<Product> get deals => products.where((p) => p.onSale).toList();
  List<Product> related(Product p) =>
      products.where((x) => x.categoryId == p.categoryId && x.id != p.id).take(8).toList();

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setCategory(String? id) {
    categoryId = id;
    notifyListeners();
  }

  void setSort(SortBy s) {
    sort = s;
    notifyListeners();
  }

  void setPrice(int min, int? max) {
    priceMin = min;
    priceMax = max;
    notifyListeners();
  }

  void setOnlyOffers(bool v) {
    onlyOffers = v;
    notifyListeners();
  }

  void resetFilters() {
    categoryId = null;
    priceMin = 0;
    priceMax = null;
    onlyOffers = false;
    notifyListeners();
  }

  void resetAll() {
    query = '';
    resetFilters();
  }

  List<Product> get results {
    final q = query.trim().toLowerCase();
    final list = products.where((p) {
      if (q.isNotEmpty &&
          !p.name.ar.toLowerCase().contains(q) &&
          !p.name.en.toLowerCase().contains(q)) {
        return false;
      }
      if (categoryId != null && p.categoryId != categoryId) return false;
      if (p.price < priceMin) return false;
      if (priceMax != null && p.price > priceMax!) return false;
      if (onlyOffers && !p.onSale) return false;
      return true;
    }).toList();

    switch (sort) {
      case SortBy.popular:
        list.sort((a, b) {
          final s = (b.bestSeller ? 1 : 0).compareTo(a.bestSeller ? 1 : 0);
          return s != 0 ? s : b.reviews.compareTo(a.reviews);
        });
      case SortBy.newest:
        list.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
      case SortBy.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortBy.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortBy.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }
}
