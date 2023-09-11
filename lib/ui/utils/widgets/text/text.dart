// ignore_for_file: prefer_const_constructors

import 'package:firebasecore/ui/utils/widgets/text/type_text.dart';
import 'package:flutter/material.dart';

class TextCus extends StatelessWidget {
  final String? title;
  final int? type;
  final int? typeSize;
  final int? typeWeight;
  final Color? color;
  final Color? backgroundColor;
  final TextAlign? align;
  final int? maxLines;
  final double? customSize;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final AlignmentGeometry? alignment;
  const TextCus(
      {Key? key,
      required this.title,
      this.type,
      this.color,
      this.backgroundColor,
      this.align,
      this.maxLines,
      this.textOverflow,
      this.fontStyle,
      this.alignment,
      this.typeSize,
      this.customSize,
      this.typeWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment == null ? Alignment.centerLeft : alignment!,
            child: Text(
              title ?? '',
              textAlign: align,
              maxLines: maxLines,
              overflow: textOverflow,
              style: TextStyle(
                  color: color ?? Colors.black,
                  fontSize: customSize ?? getFontSize(typeSize, context),
                  fontWeight: getFontWeight(typeWeight),
                  backgroundColor: backgroundColor ?? Colors.transparent),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 3, top: 3),
            child: Text(
              title ?? '',
              textAlign: align,
              maxLines: maxLines,
              overflow: textOverflow,
              style: TextStyle(
                  color: color ?? Colors.black,
                  fontSize: customSize ?? getFontSize(typeSize, context),
                  fontWeight: getFontWeight(typeWeight),
                  backgroundColor: backgroundColor ?? Colors.transparent),
            ),
          );
  }
}
