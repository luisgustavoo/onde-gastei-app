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

    final oldValueLength = oldValue.text.length;
    final newValueLength = newValue.text.length;
    final lastDigitNewValue = newValue.text.substring(newValueLength - 1);

    // Estou apagando, retorna o novo texto
    if (oldValueLength > newValueLength) {
      return newValue;
    }

    // Verifico o último caracter digitado para ver se é um número
    // se não for retorno o último texto digitado
    if (oldValueLength < newValueLength) {
      try {
        int.parse(lastDigitNewValue);
      } on FormatException {
        return oldValue;
      }
    }

    var result = newValue.text;

    // Adiciona a "/" na última posição da string se a quantidade de caracteres for 2 ou 5
    if (newValueLength == 2 || newValueLength == 5) {
      result += '/';
    }

    // Verifica se contém a "/" iniciando a verificação à partir da penultima posição da string
    final containsSlash = result.contains('/', newValueLength - 1);

    // Adiciona a "/" (se não existir) na penultima posição da string se a quantidade de caracteres for 3 ou 6
    if ((result.length == 3 || result.length == 6) && (!containsSlash)) {
      result = result.replaceAllMapped(
        RegExp('.{${newValueLength - 1}}'),
        (match) => '${match.group(0)}/',
      );
    }

    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
