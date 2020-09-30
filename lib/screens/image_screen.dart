import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ImageScreen extends StatelessWidget {
  final String url;
  ImageScreen(this.url);

  Future<void> _shareImageFromUrl() async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Image', 'image.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.05,
        actions: [
          IconButton(
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.share : Icons.share,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async => await _shareImageFromUrl(),
          ),
        ],
      ),
      body: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
