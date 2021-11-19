import 'package:flutter/material.dart';

class OndeGasteiTextForm extends StatelessWidget {
  OndeGasteiTextForm(
      {required this.label,
      this.controller,
      this.validator,
      this.obscureText = false,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputType = TextInputType.text,
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
  final Icon? prefixIcon;
  final ValueNotifier<bool> _obscureTextNotifier;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, value, child) {
        return TextFormField(
          key: key,          
          obscureText: value,
          controller: controller,
          validator: validator,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: prefixIcon,
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      _obscureTextNotifier.value = !_obscureTextNotifier.value;
                    },
                    icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                    splashRadius: 10,
                  )
                : suffixIcon,
          ),
        );
      },
    );
  }
}
