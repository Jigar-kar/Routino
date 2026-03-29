import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyNotifier extends Notifier<String> {
  static const _currencyKey = 'selected_currency';

  @override
  String build() {
    _initCurrency();
    return '\$'; // Default currency
  }

  Future<void> _initCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString(_currencyKey);
    if (savedCurrency != null) {
      state = savedCurrency;
    }
  }

  Future<void> setCurrency(String currencySymbol) async {
    state = currencySymbol;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencySymbol);
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, String>(() {
  return CurrencyNotifier();
});
