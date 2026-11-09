import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._p) : _ids = (_p.getStringList('favs') ?? <String>[]).toSet();
  final SharedPreferences _p;
  final Set<String> _ids;

  Set<String> get ids => _ids;
  bool isFav(String id) => _ids.contains(id);

  void toggle(String id) {
    _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
    _p.setStringList('favs', _ids.toList());
    notifyListeners();
  }
}
