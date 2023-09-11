// ignore_for_file: dead_code, avoid_print

import 'package:flutter/material.dart';
import '../../color/color.dart';
import 'type_textfield.dart';

class TextFieldCus extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Function()? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final int? type;
  final bool? isReadOnly;
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final String? errorText;
  const TextFieldCus(
      {super.key,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText,
      this.onChanged,
      this.onSubmitted,
      this.onTap,
      this.type,
      this.isReadOnly,
      required this.controller,
      this.onFieldSubmitted,
      this.validator,
      this.errorText});

  TextInputType getInputType() {
    switch (type) {
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.price:
      case TextFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool valid = true;

    return Container(
      margin: const EdgeInsets.only(top: 7, bottom: 7),
      child: Theme(
          data: Theme.of(context).copyWith(primaryColor: themeColor, colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.grey)),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: onFieldSubmitted,
            controller: controller,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            obscureText: obscureText == null ? false : obscureText!,
            maxLines: type == TextFieldType.multiline ? 5 : 1,
            readOnly: type == TextFieldType.readOnly ? true : false,
            cursorColor: themeColor,
            enableSuggestions: !(type == TextFieldType.password),
            autocorrect: !(type == TextFieldType.password),
            keyboardType: getInputType(),
            textInputAction: type != TextFieldType.multiline ? TextInputAction.next : TextInputAction.none,
            onEditingComplete: onChanged,
            validator: validator,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(10),
                //   borderSide: const BorderSide(color: Colors.grey),
                // ),
                errorText: errorText,
                errorBorder: !valid
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: !valid ? Colors.red : const Color(0xFF0F62AC)),
                        borderRadius: const BorderRadius.all(Radius.circular(10)))
                    : null,
                labelText: labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                suffixIcon: suffixIcon,
                iconColor: Colors.black,
                fillColor: Colors.white,
                filled: true),
          )),
    );
  }
}
