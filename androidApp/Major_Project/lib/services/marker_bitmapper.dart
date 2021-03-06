import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//global variables
//sort this out later...
//might be okay? the marker icons only have to be converted to bitmap once, for non profile images
//it would take too long to convert individual profile icons anyway so either just don't, or async generate and cache them here
class MarkerBitmapper {
  init(){
    fetchMessageIcon();
    fetchBunnyIcon();
  }
  BitmapDescriptor messageIcon;
  BitmapDescriptor bunnyIcon;

  MarkerBitmapper._privateConstructor();

  static final MarkerBitmapper _instance = MarkerBitmapper._privateConstructor();

  static MarkerBitmapper get instance => _instance;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
  fetchMessageIcon() {
    getBytesFromAsset('assets/images/message.png', 128).then((onValue) {
      messageIcon = BitmapDescriptor.fromBytes(onValue);
    }
    );
  }

  fetchBunnyIcon() {
    getBytesFromAsset('assets/images/bunny.jpg', 128).then((onValue) {
      bunnyIcon = BitmapDescriptor.fromBytes(onValue);
    }
    );
  }
}