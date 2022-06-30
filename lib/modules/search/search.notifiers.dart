import 'package:flutter/foundation.dart';

class Notifier<T> extends ChangeNotifier {
  T _value;
  Notifier(this._value);

  set value(T value) {
    print("Notifier| set value $value");
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  T get value {
    print("notifier|get $_value");
    return _value;
  }
}

class SinceAgoNotifier extends ChangeNotifier {
  final Map<String, String> sinceAgoDD = {
    "1": "seconds",
    "2": "minutes",
    "3": "hours",
    "4": "days"
  };
  String _selectedVal = "seconds";

  Map<String, String> get ddItems => sinceAgoDD;
  String get selectedVal => _selectedVal;
  set selectedVal(final String val) {
    if (val != null) {
      _selectedVal = val;
    }
    notifyListeners();
  }
}
