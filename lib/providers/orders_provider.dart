import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/store_repository.dart';
import '../models/order.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._p, this._repo) {
    final raw = _p.getString('orders');
    if (raw != null) {
      try {
        for (final j in jsonDecode(raw) as List) {
          orders.add(Order.fromJson(Map<String, dynamic>.from(j)));
        }
      } catch (_) {}
    }
  }

  final SharedPreferences _p;
  final StoreRepository _repo;
  final List<Order> orders = [];

  Future<Order> place(Order o) async {
    final saved = await _repo.placeOrder(o);
    orders.insert(0, saved);
    _p.setString('orders', jsonEncode(orders.map((e) => e.toJson()).toList()));
    notifyListeners();
    return saved;
  }
}
