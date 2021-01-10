import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';



class PlaceSelectedImage extends StatefulWidget{
  final String _path;
  final List<String> _photoPath;
  PlaceSelectedImage(this._path,this._photoPath);
  @override
  PlaceSelectedImageState createState() => PlaceSelectedImageState(_path,_photoPath);
}

class PlaceSelectedImageState extends State<PlaceSelectedImage>{
  final String _path;
  final List<String> _photoPath;
  PlaceSelectedImageState(this._path,this._photoPath);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: CarouselSlider(
          options: CarouselOptions(
              initialPage: _photoPath.indexOf(_path),
              height: double.infinity,
              autoPlayInterval: Duration(seconds: 10),
              viewportFraction: 1,
              autoPlay: true,
              enlargeCenterPage: false
          ),
          items: [
            for(String path in _photoPath)
              PhotoView(
                  imageProvider: FileImage(File(path))
              ),
          ],
        )

    );
  }

}
