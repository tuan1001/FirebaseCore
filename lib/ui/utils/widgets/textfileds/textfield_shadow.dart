// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebasecore/ui/utils/color/color.dart';
import 'package:flutter/material.dart';

class TextFieldShadow extends StatelessWidget {
  final bool tap;
  final double elevation;
  final String hintText;
  final TextEditingController controller;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;

  const TextFieldShadow({
    Key? key,
    required this.tap,
    required this.elevation,
    required this.hintText,
    required this.controller,
    required this.onTap,
    required this.onTapOutside,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      elevation: tap == true ? elevation : 0,
      shadowColor: Colors.grey,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: TextField(
            onTap: onTap,
            onTapOutside: onTapOutside,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.all(10),
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
              ),
            ),
            cursorColor: componentPrimaryColor,
            controller: controller),
      ),
    );
  }
}
