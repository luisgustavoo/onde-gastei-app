import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OndeGasteiTextForm extends StatelessWidget {
  OndeGasteiTextForm({
    required this.label,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    super.key,
  })  : _obscureTextNotifier = ValueNotifier<bool>(obscureText),
        assert(
          !(obscureText == true && suffixIcon != null),
          'obscureText não pode ser adicionado junto com o suffixIcon',
        );

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final ValueNotifier<bool> _obscureTextNotifier;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final bool enabled;

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
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: prefixIcon,
            labelStyle: const TextStyle(color: Colors.red),
            fillColor: enabled ? null : Colors.grey[300],
            // labelStyle: const TextStyle(color: Constants.textColorDisabled),
            // contentPadding: const EdgeInsets.only(left: 8),
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      _obscureTextNotifier.value = !_obscureTextNotifier.value;
                    },
                    icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                    splashRadius: 20.r,
                  )
                : suffixIcon,
          ),
        );
      },
    );
  }
}
