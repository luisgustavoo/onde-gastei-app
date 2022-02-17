import 'package:flutter/material.dart';

class Validators {
  Validators._();

  static FormFieldValidator<String> value() {
    return (value) {
      var parseValue = 0.0;

      if (value == null) {
        return 'Informe o valor';
      }
      if (value.isEmpty) {
        return 'Informe o valor';
      }

      try {
        parseValue = parseLocalFormatValueToIso4217(value);
      } on FormatException {
        return 'Valor invalido';
      }

      if (parseValue <= 0) {
        return 'Informe o valor';
      }

      return null;
    };
  }

  static FormFieldValidator<String> date() {
    return (date) {
      if (date == null) {
        return 'Informe a data';
      }

      try {
        parseLocalFormatDateToIso8601(date);
      } on FormatException {
        return 'Data inválida';
      }

      return null;
    };
  }

  static double parseLocalFormatValueToIso4217(String price) {
    try {
      final priceToDouble = price
          .replaceAll(r'R$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();

      return double.parse(priceToDouble);
    } on Exception {
      throw const FormatException();
    }
  }

  static DateTime parseLocalFormatDateToIso8601(String date) {
    try {
      final dateByPosition = date.split('/');
      final day = int.parse(dateByPosition[0]);
      final month = int.parse(dateByPosition[1]);
      final year = int.parse(dateByPosition[2]);

      if (day < 1 || day > 31) {
        throw const FormatException();
      }

      if (month < 1 || month > 12) {
        throw const FormatException();
      }

      if (year < 1900 || year > 2099) {
        throw const FormatException();
      }

      return DateTime(year, month, day);
    } on Exception {
      throw const FormatException();
    }
  }
}
