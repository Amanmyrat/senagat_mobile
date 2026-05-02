import 'package:flutter/services.dart';

class CustomMaskFormatter extends TextInputFormatter {
  final String prefix; // '12' or '60'
  final String mask;   // '## ######'

  CustomMaskFormatter({
    required this.prefix,
    required this.mask,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove non-digits
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 👉 Apply prefix ONLY when input is empty -> first typing
    if (oldValue.text.isEmpty && digits.isNotEmpty) {
      if (!digits.startsWith(prefix)) {
        digits = prefix + digits;
      }
    }

    // 👉 Do NOT force prefix again later
    String formatted = '';
    int digitIndex = 0;

    for (int i = 0; i < mask.length; i++) {
      if (digitIndex >= digits.length) break;

      if (mask[i] == '#') {
        formatted += digits[digitIndex];
        digitIndex++;
      } else {
        formatted += mask[i];
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    // Fix invalid month
    if (digits.length >= 2) {
      int month = int.tryParse(digits.substring(0, 2)) ?? 0;
      if (month > 12) {
        digits = '12' + digits.substring(2);
      } else if (month == 0) {
        digits = '01' + digits.substring(2);
      }
    }

    String formatted = '';
    if (digits.length >= 2) {
      formatted = digits.substring(0, 2);
      if (digits.length > 2) {
        formatted += '/' + digits.substring(2);
      }
    } else {
      formatted = digits;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DynamicPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String mask = digits.startsWith('12')
        ? '## ######'
        : '### ######';

    String formatted = '';
    int digitIndex = 0;

    for (int i = 0; i < mask.length; i++) {
      if (digitIndex >= digits.length) break;

      if (mask[i] == '#') {
        formatted += digits[digitIndex];
        digitIndex++;
      } else {
        formatted += mask[i];
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}