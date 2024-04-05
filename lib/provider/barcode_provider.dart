import 'package:barcode_genrator/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider =
    ChangeNotifierProvider<BarcodeProvider>((ref) => BarcodeProvider());

class BarcodeProvider extends ChangeNotifier {
  XFile? get image => _image;
  XFile? _image;

  void addImage() async {
    var image = await Utility.pickImages(source: ImageSource.camera);
    _image = image;
    notifyListeners();
  }
}
