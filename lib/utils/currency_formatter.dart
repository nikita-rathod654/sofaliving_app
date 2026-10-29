import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num amount) {
    return _inrFormatter.format(amount);
  }

  static String formatWithSign(num amount) {
    if (amount > 0) {
      return '+${_inrFormatter.format(amount)}';
    } else if (amount < 0) {
      return '−${_inrFormatter.format(amount.abs())}';
    }
    return _inrFormatter.format(0);
  }
}
