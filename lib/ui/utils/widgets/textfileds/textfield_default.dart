import 'package:firebasecore/ui/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';

class TextFieldDefault extends StatelessWidget {
  final GlobalKey? globalKey;
  final TextEditingController controller;
  final String? hintText;
  final bool? multiLine;
  final bool? expand;
  final double? height;
  final String? type;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? radius;
  final String? errorText;
  final bool? obscureText;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;

  const TextFieldDefault(
      {super.key,
      required this.controller,
      this.hintText,
      this.multiLine,
      this.expand,
      this.height,
      this.type,
      this.prefixIcon,
      this.suffixIcon,
      this.radius,
      this.errorText,
      this.focusNode,
      this.onTap,
      this.globalKey,
      this.onSubmitted,
      this.onChanged,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
    return TextField(
      key: globalKey,
      focusNode: focusNode,
      controller: controller,
      keyboardType: multiLine == true ? TextInputType.multiline : null,
      cursorColor: themeColor,
      maxLines: multiLine == true ? 5 : 1,
      enabled: true,
      onTap: () {
        handleOnTap(type, globalKey, context);
        //controller.clear();
      },
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      obscureText: obscureText == null ? false : obscureText!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15, 10.0, 0, 10.0),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
          borderSide: const BorderSide(width: 1, color: themeColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
          borderSide: const BorderSide(width: 1, color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
        ),

        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
            borderSide: const BorderSide(
              width: 1,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)), borderSide: const BorderSide(width: 1, color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)), borderSide: const BorderSide(width: 1, color: Colors.grey)),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
        //errorText: snapshot.error,
      ),
      //controller: _passwordController,
      //onChanged: _authenticationFormBloc.onPasswordChanged,
    );
  }

  handleOnTap(String? type, GlobalKey? globalKey, BuildContext context) {
    switch (type) {
      case null:
        ensureVisibleOnTextArea(textfieldKey: globalKey);
        break;
      case 'date':
        FocusScope.of(context).requestFocus(FocusNode());
        showPickerCustomizeUI(context, 'date');
        break;
      case 'time':
        FocusScope.of(context).requestFocus(FocusNode());
        showPickerCustomizeUI(context, 'time');
        break;
      default:
        break;
    }
  }

  Future<void> ensureVisibleOnTextArea({GlobalKey? textfieldKey}) async {
    final keyContext = textfieldKey?.currentContext;

    if (keyContext != null) {
      await Future.delayed(const Duration(milliseconds: 500)).then(
        (value) => Scrollable.ensureVisible(
          keyContext,
          alignment: 0.2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
        ),
      );
    } else {}
  }

  showPickerCustomizeUI(BuildContext context, String type) {
    const itemExtent = 55.0;
    const bgColor = Colors.white;
    const txtColor = Colors.black;
    const txtStyle = TextStyle(color: txtColor);
    final selectColor = Colors.black.withOpacity(0.1);
    final delimiterChild = Align(
      alignment: Alignment.center,
      child: Container(width: 30, height: itemExtent, color: selectColor),
    );

    Picker(
        smooth: 200,
        height: MediaQuery.of(context).size.height / 2.5,
        itemExtent: itemExtent,
        backgroundColor: Colors.white,
        containerColor: bgColor,
        selectionOverlay: Container(height: itemExtent, color: selectColor),
        headerDecoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
        textStyle: txtStyle,
        cancelTextStyle: txtStyle,
        confirmTextStyle: txtStyle,
        cancelText: 'Hủy',
        confirmText: 'Chọn',
        selectedTextStyle: const TextStyle(color: txtColor, fontSize: 20),
        adapter: type == 'time'
            ? DateTimePickerAdapter(type: PickerDateTimeType.kHM, minHour: 8, maxHour: 18)
            : DateTimePickerAdapter(
                customColumnType: [2, 1, 0],
                type: PickerDateTimeType.kDMY,
                value: controller.text == '' ? DateTime.now() : DateTime.parse(controller.text)),
        delimiter: [
          PickerDelimiter(column: 0, child: delimiterChild),
          PickerDelimiter(
              column: 2,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 15,
                  height: itemExtent,
                  color: selectColor,
                  alignment: Alignment.center,
                  child: type == 'time' ? const Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: txtColor)) : null,
                ),
              )),
          PickerDelimiter(column: 4, child: delimiterChild),
        ],
        onCancel: () {
          controller.text = '';
        },
        onConfirm: (Picker picker, List value) {
          type == 'time'
              ? controller.text = formateDate(picker.adapter.text, 'HH:mm')
              : controller.text = formateDate(picker.adapter.text, 'yyyy-MM-dd');

          FocusScope.of(context).requestFocus(FocusNode());
        }).showModal(context, builder: (context, view) {
      return Material(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: view,
          ));
    }, backgroundColor: Colors.transparent);
  }
}

String formateDate(String date, String type) {
  if (date != '') {
    String dateFormate = DateFormat(type).format(DateTime.parse(date));
    return dateFormate;
  } else {
    return '';
  }
}
