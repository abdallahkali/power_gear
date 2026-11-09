import 'package:flutter/foundation.dart';

class NavProvider extends ChangeNotifier {
  int index = 0;
  void go(int i) {
    index = i;
    notifyListeners();
  }
}
