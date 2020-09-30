import 'package:flutter/material.dart';
import 'package:photo_gallery/screens/image_screen.dart';

class PhotoItem extends StatelessWidget {
  final String url;
  PhotoItem(this.url);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) {
          return Image.asset('assets/images/error-image.png');
        },
        frameBuilder: (context, child, _, __) => GestureDetector(
          child: child,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageScreen(url)),
            );
          },
        ),
      ),
    );
  }
}
