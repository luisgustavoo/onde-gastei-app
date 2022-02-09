import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatterPtbr extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    final format = NumberFormat.currency(
      locale: 'pt-BR',
      symbol: r'R$',
      decimalDigits: 2,
    );
    final value = double.parse(
      newValue.text
          .replaceAll('.', '')
          .replaceAll(',', '')
          .replaceAll(r'R$', ''),
    );
    final result = format.format(value / 100);

    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
