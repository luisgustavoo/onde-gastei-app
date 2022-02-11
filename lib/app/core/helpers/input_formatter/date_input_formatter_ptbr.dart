import 'package:flutter/services.dart';

class DateInputFormatterPtbr extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final digit = newValue.text.substring(newValue.text.length - 1);

    if (oldValue.text.length < newValue.text.length) {
      try {
        int.parse(digit);
      } on FormatException {
        return oldValue;
      }
    }

    var result = newValue.text;

    if ((newValue.text.length == 2 || newValue.text.length == 5) &&
        (oldValue.text.length < newValue.text.length)) {
      result += '/';
    }

    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
