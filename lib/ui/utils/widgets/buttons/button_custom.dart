// ignore_for_file: library_private_types_in_public_api

import 'package:firebasecore/ui/utils/color/color.dart';
import 'package:firebasecore/ui/utils/widgets/text/text.dart';
import 'package:firebasecore/ui/utils/widgets/text/type_text.dart';
import 'package:flutter/material.dart';

class AnimationButon extends StatefulWidget {
  final Function onPressed;
  final double shrinkScale;
  final String title;

  final Color? shadow;
  final Color? colorButon;
  final double? width;
  final double? height;
  final IconData? icon;
  const AnimationButon({
    super.key,
    required this.onPressed,
    this.shrinkScale = 0.9,
    required this.title,
    this.shadow,
    this.colorButon,
    this.width,
    this.icon,
    this.height,
  });

  @override
  _AnimationButonState createState() => _AnimationButonState();
}

class _AnimationButonState extends State<AnimationButon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _controller.reverse();
        });
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: widget.shrinkScale,
        ).animate(_controller),
        child: Container(
          height: widget.height ?? 50,
          width: widget.width,
          decoration: BoxDecoration(color: widget.colorButon ?? themeColor, borderRadius: BorderRadius.circular(10), boxShadow: const []),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    )
                  : Container(),
              TextCus(
                title: widget.title,
                color: Colors.white,
                typeWeight: TextCusType.header,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
