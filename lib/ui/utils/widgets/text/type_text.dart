import 'package:flutter/cupertino.dart';

class TextCusType {
  static const int label = 1;
  static const int text = 2;
  static const int subtitle = 3;
  static const int title = 4;
  static const int header = 5;
  static const int date = 6;
  static const int time = 7;
}

double? getFontSize(int? type, BuildContext context) {
  switch (type) {
    case TextCusType.label:
      return 10;
    case TextCusType.subtitle:
      return 12;
    case TextCusType.title:
      return 20;
    case TextCusType.header:
      return 28;
    default:
      return 14;
  }
}

FontWeight? getFontWeight(int? type) {
  switch (type) {
    case TextCusType.label:
    case TextCusType.text:
      return FontWeight.normal;
    case TextCusType.subtitle:
    case TextCusType.title:
    case TextCusType.header:
      return FontWeight.w700;
    default:
      return FontWeight.normal;
  }
}
