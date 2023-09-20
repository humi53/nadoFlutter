// Widget 을 return 하는 method
import 'package:flutter/material.dart';

Widget inputFormField({
  required Function(String) setValue,
  int maxLines = 1,
  int maxLength = 30,
  String? labelText,
  String? helpText,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: (value) => setValue(value),
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helpText ?? "$maxLength 글자 제한",
        helperStyle: const TextStyle(color: Colors.blue),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    ),
  );
}
