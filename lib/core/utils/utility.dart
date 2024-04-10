import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Utility {
  static Future<XFile?> pickImages({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      return image;
    } on PlatformException catch (ex) {
      debugPrint(ex.message);
      return null;
    }
  }
}
