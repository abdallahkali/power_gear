import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/brand.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'catalog_provider.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._p, this._catalog) {
    final raw = _p.getString('cart');
    if (raw != null) {
      try {
        for (final j in jsonDecode(raw) as List) {
          _items.add(CartItem.fromJson(Map<String, dynamic>.from(j)));
        }
      } catch (_) {}
    }
  }

  final SharedPreferences _p;
  final CatalogProvider _catalog;
  final List<CartItem> _items = [];
  String? promo;

  int get count => _items.fold(0, (s, i) => s + i.qty);

  List<CartLine> get lines {
    final out = <CartLine>[];
    for (final i in _items) {
      final p = _catalog.byId(i.productId);
      if (p != null) out.add(CartLine(i, p));
    }
    return out;
  }

  int get subtotal => lines.fold(0, (s, l) => s + l.total);
  int get discount => promo == null ? 0 : (subtotal * Brand.promoPercent / 100).round();
  int get shipping => (subtotal == 0 || subtotal >= Brand.freeShippingFrom) ? 0 : Brand.shippingFee;
  int get total => subtotal - discount + shipping;

  void _save() {
    _p.setString('cart', jsonEncode(_items.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  void add(Product p, {int variantIndex = -1, int qty = 1}) {
    final key = '${p.id}|$variantIndex';
    final i = _items.indexWhere((e) => e.key == key);
    if (i >= 0) {
      _items[i].qty += qty;
    } else {
      _items.add(CartItem(p.id, variantIndex, qty));
    }
    _save();
  }

  void setQty(CartItem item, int qty) {
    if (qty < 1) return;
    item.qty = qty;
    _save();
  }

  void remove(CartItem item) {
    _items.remove(item);
    _save();
  }

  void restore(CartItem item) {
    _items.add(item);
    _save();
  }

  void clear() {
    _items.clear();
    promo = null;
    _save();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == Brand.promoCode) {
      promo = Brand.promoCode;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    promo = null;
    notifyListeners();
  }
}
