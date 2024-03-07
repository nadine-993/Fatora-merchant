import 'package:flutter/material.dart';

extension EmailValidator on String? {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this!);
  }
}


extension TextEditingValueExtension on TextEditingValue {
TextEditingValue clampTextEditingValue(TextEditingValue value) {
  // If the value is not empty, clamp it within the range of this formatter
  if (value.text.isNotEmpty) {
    double parsedValue = double.parse(value.text.replaceAll(',', ''));
    if (parsedValue < double.minPositive) {
      parsedValue = double.minPositive;
    }
    if (parsedValue > double.maxFinite) {
      parsedValue = double.maxFinite;
    }
    String newText = parsedValue.toStringAsFixed(2);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  // Return new value if new text is empty
  return value;
}
}

extension EndOfDay on DateTime {
  DateTime get endOfDay {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
      999,
      999,
    );
  }
}