import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Forces the first letter of a name to stay uppercase while the user types.
class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  const CapitalizeFirstLetterFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final updated = capitalizeFirstLetter(newValue.text);
    if (updated == newValue.text) return newValue;

    return TextEditingValue(
      text: updated,
      selection: newValue.selection,
    );
  }
}

String capitalizeFirstLetter(String value) {
  var index = 0;
  while (index < value.length && value[index].trim().isEmpty) {
    index++;
  }
  if (index >= value.length) return value;

  final first = value[index];
  final upper = first.toUpperCase();
  if (first == upper) return value;
  return value.replaceRange(index, index + first.length, upper);
}

class SumInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // remove all non-digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // format number
    final number = int.parse(digitsOnly);
    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}