import 'package:intl/intl.dart';

String formatNumberWithSeparator(double? num) {
  if (num == null) return '0.00';
  final formatter = NumberFormat('#,##0.00########', 'en_US');
  return formatter.format(num);
}

extension FormatNumberDecimal on double {
  String toStringAsFixedLowValue(int precision, int precisionLowValue) {
    if (this < 1) {
      return toStringAsFixed(precisionLowValue);
    }
    return toStringAsFixed(precision);
  }
}
