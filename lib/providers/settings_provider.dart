import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._p)
      : _mode = _parse(_p.getString('theme')),
        _locale = Locale(_p.getString('lang') ?? 'ar');
  final SharedPreferences _p;
  ThemeMode _mode;
  Locale _locale;

  ThemeMode get themeMode => _mode;
  Locale get locale => _locale;
  bool get isAr => _locale.languageCode == 'ar';

  static ThemeMode _parse(String? s) => switch (s) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  void setTheme(ThemeMode m) {
    _mode = m;
    _p.setString('theme', m.name);
    notifyListeners();
  }

  void setLang(String code) {
    _locale = Locale(code);
    _p.setString('lang', code);
    notifyListeners();
  }

  void toggleLang() => setLang(isAr ? 'en' : 'ar');
}
