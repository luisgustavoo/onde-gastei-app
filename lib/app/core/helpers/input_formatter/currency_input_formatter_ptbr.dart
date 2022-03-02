import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatterPtBr extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    try {
      double.parse(
        newValue.text
            .replaceAll('.', '')
            .replaceAll(',', '')
            .replaceAll(r'R$', ''),
      );
    } on FormatException {
      return newValue;
    }

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final value = double.parse(
      newValue.text
          .replaceAll('.', '')
          .replaceAll(',', '')
          .replaceAll(r'R$', ''),
    );

    final result = NumberFormat.currency(
      locale: 'pt-BR',
      symbol: r'R$',
      decimalDigits: 2,
    ).format(value / 100);

    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
