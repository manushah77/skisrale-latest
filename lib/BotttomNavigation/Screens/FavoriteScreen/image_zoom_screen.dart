import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../Constant/color.dart';

class ImageZoomScreen extends StatefulWidget {
  String? image;
   ImageZoomScreen(this.image);

  @override
  State<ImageZoomScreen> createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text('Image'),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Image.asset(
                    'assets/icons/la.png',
                    color: Colors.white,
                    scale: 4.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 500,
              width: double.infinity,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider: NetworkImage(widget.image!),
                filterQuality: FilterQuality.high,
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 3.5,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
