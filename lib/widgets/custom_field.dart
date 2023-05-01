import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final TextInputType? textInputType;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onChanged;
  final String initValue;
  const CustomInputField(
      {super.key,
      this.hintText,
      this.labelText,
      this.helperText,
      this.icon,
      this.textInputType,
      this.obscureText =
          false, // si no se envia va tener el valor por defecto en false
      required this.validator,
      required this.onChanged, required this.initValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      initialValue: initValue,
      textCapitalization: TextCapitalization.words,
      keyboardType: textInputType,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          prefixIcon: icon == null ? null : Icon(icon)
          ),
      onChanged: onChanged
    );
  }
}
