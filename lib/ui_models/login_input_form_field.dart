// Widget 을 return 하는 method
import 'package:flutter/material.dart';

Widget logininputFormField({
  required FocusNode focusNode,
  required Function(String) setValue,
  required Function(String?) validator,
  String? hintText,
  String? helpText,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      focusNode: focusNode,
      validator: (value) => validator(value),
      onChanged: (value) => setValue(value),
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helpText,
        helperStyle: const TextStyle(color: Colors.blue),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    ),
  );
}
