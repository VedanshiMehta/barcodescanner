import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../../core/routes/navigation_service.dart';
import '../../../core/utils/image_handler.dart';
import '../../../core/utils/utility.dart';
import '../../../core/widgets/adaptive_alert_dialog.dart';

final scanningProvider =
    ChangeNotifierProvider<BarcodeProvider>((ref) => BarcodeProvider());

class BarcodeProvider extends ChangeNotifier {
  XFile? get image => _image;
  XFile? _image;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  String? get barcodeText => _barcodeText;
  String? _barcodeText;
  String get appbarText => _appbarText;
  String _appbarText = "Select Barcode";

  void addImage() async {
    var image = await Utility.pickImages(source: ImageSource.camera);
    _image = image;
    notifyListeners();
  }

  Future<void> scanBarcode(
      {required Offset? croppedStart,
      required Offset? croppedEnd,
      required double width,
      required File? file}) async {
    try {
      _barcodeText = "";
      notifyListeners();
      if (file != null) {
        img.Image? decodedImage = img.decodeImage(await file.readAsBytes());

        if (decodedImage != null) {
          Rect rect = Rect.fromPoints(croppedStart!, croppedEnd!);
          //coropped Image
          img.Image croppedImage = ImageHandler.crop(decodedImage, rect, width);

          //Convert Croppedfile
          File convertedFile =
              await ImageHandler.convertImageToFile(croppedImage, file.path);

          //Convert file to input image
          final inputImage = InputImage.fromFilePath(convertedFile.path);

          final barcodes = await _barcodeScanner.processImage(inputImage);

          String text = "";
          if (barcodes.isEmpty) {
            _showAlertDialog("A barcode was not found");
          } else {
            for (final barcode in barcodes) {
              text += '${barcode.displayValue}';
            }
            _barcodeText = text;
            _showAlertDialog("Is your text: $barcodeText");
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error on scanning: ${e.toString()}");
    } finally {
      _barcodeScanner.close();
    }
  }

  void _showAlertDialog(String content) {
    AdaptiveAlerts().showAlert(
        context: NavigationService.navigatorKey.currentState!.context,
        title: "Striden",
        cancelText: "Retry",
        acceptText: "Continue",
        content: content,
        accept: () {
          _appbarText = "Select Receiver Name";
          notifyListeners();
          Navigator.of(NavigationService.navigatorKey.currentState!.context)
              .pop();
        },
        cancel: () {
          Navigator.of(NavigationService.navigatorKey.currentState!.context)
              .pop();
        });
  }
}
