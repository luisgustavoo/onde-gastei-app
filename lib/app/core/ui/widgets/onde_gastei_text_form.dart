import 'package:flutter/material.dart';

class OndeGasteiTextForm extends StatelessWidget {
  OndeGasteiTextForm(
      {required this.label,
      this.controller,
      this.validator,
      this.obscureText = false,
      this.suffixIcon,
      Key? key})
      : _obscureTextNotifier = ValueNotifier<bool>(obscureText),
        assert(!(obscureText == true && suffixIcon != null),
            'obscureText não pode ser adicionado junto com o suffixIcon'),
        super(key: key);

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final IconButton? suffixIcon;
  final ValueNotifier<bool> _obscureTextNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, value, child) {
        return TextFormField(
          obscureText: value,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      _obscureTextNotifier.value = !_obscureTextNotifier.value;
                    },
                    icon: Icon(value ? Icons.visibility : Icons.visibility_off),
                    splashRadius: 10,
                  )
                : suffixIcon,
          ),
        );
      },
    );
  }
}
