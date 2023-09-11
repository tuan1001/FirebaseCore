import 'package:firebasecore/ui/utils/widgets/text/text.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color? shadow;
  final Color? colorButon;
  final double? width;
  final IconData? icon;
  const DefaultButton({super.key, required this.onPressed, required this.title, this.shadow, this.colorButon, this.width, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(color: colorButon ?? Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
          // BoxShadow(color: shadow ?? themeColor, spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2)),
          // const BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 8, offset: Offset(-3, -3))
        ]),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: Colors.white,
                  )
                : Container(),
            TextCus(
              title: title,
              color: Colors.white,
            ),
          ],
        )),
      ),
    );
  }
}
