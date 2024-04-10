import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageHandler {
  static img.Image crop(img.Image image, Rect cropRect, double imageViewWidth) {
    double scalingFactorX = image.width / imageViewWidth;

    int left = (cropRect.left * scalingFactorX).toInt();
    int top = (cropRect.top * scalingFactorX).toInt();
    int width = (cropRect.width * scalingFactorX).toInt();
    int height = (cropRect.height * scalingFactorX).toInt();
    return img.copyCrop(image, x: left, y: top, width: width, height: height);
  }

  static Future<File> convertImageToFile(img.Image image, String path) async {
    final newPath = "${path.substring(0, path.lastIndexOf('.'))}.png";
    final imgBytes = img.encodePng(image);
    final convertedFile = await File(newPath).writeAsBytes(imgBytes);
    return convertedFile;
  }
}
