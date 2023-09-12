import 'package:flutter/material.dart';

class ImageThumpnail extends StatelessWidget {
  final String imageUrl;
  const ImageThumpnail({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
