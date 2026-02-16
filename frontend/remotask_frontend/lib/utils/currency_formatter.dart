import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final Map<String, NumberFormat> _formatters = {};

  /// Formats amount with proper currency symbol and decimal places
  /// Examples: formatCurrency(500.00, 'USD') -> 'USD 500.00'
  ///           formatCurrency(50000, 'KES') -> 'KES 50,000.00'
  static String formatCurrency(double amount, String currencyCode) {
    _formatters.putIfAbsent(currencyCode, () => NumberFormat.currency(
      symbol: '$currencyCode ',
      decimalDigits: 2,
    ));
    return _formatters[currencyCode]!.format(amount);
  }

  /// Formats amount with currency symbol only (no code)
  /// Examples: formatAmount(500.00, 'USD') -> '\$500.00'
  static String formatAmount(double amount, String currencyCode) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'KES': 'KSh ',
      'NGN': '₦',
    };
    final symbol = symbols[currencyCode] ?? '$currencyCode ';
    return '$symbol${NumberFormat('#,##0.00').format(amount)}';
  }

  /// Formats amount for display in UI with proper spacing
  static String formatDisplay(double amount, String currencyCode) {
    return '$currencyCode ${NumberFormat('#,##0.00').format(amount)}';
  }
}
