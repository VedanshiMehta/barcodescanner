import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'provider/barcode_provider.dart';

class CameraView extends ConsumerStatefulWidget {
  const CameraView({super.key});

  @override
  ConsumerState<CameraView> createState() => CameraViewState();
}

class CameraViewState extends ConsumerState<CameraView> {
  Offset? _startDrag;
  Offset? _currentDrag;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<XFile?> _cropImage(XFile? imageFile) async {
    if (imageFile == null) return null;

    try {
      final image = img.decodeImage(File(imageFile.path).readAsBytesSync());

      final left = (_startDrag!.dx).toInt();
      final top = (_startDrag!.dy).toInt();
      final width = ((_currentDrag!.dx - _startDrag!.dx)).toInt();
      final height = ((_currentDrag!.dy - _startDrag!.dy)).toInt();

      final croppedImage =
          img.copyCrop(image!, x: left, y: top, width: width, height: height);
      if (croppedImage == null) {
        print('Error: Failed to crop image.');
        return null;
      }

      final croppedBytes = img.encodePng(croppedImage);
      final croppedFile = File('${imageFile.path}_cropped.png')
        ..writeAsBytesSync(croppedBytes);
      print('Cropped image size: ${croppedFile.lengthSync()} bytes');
      final croppedFileBytes = croppedFile.readAsBytesSync();
      return XFile.fromData(croppedFileBytes, name: croppedFile.path);
    } catch (e) {
      print("Error cropping image: $e");
    }
  }

  Future<void> _processImage(XFile? image) async {
    try {
      if (image != null) {
        var croppedImage = await _cropImage(image);
        if (croppedImage != null) {
          print(
              'Cropped image after beim size: ${croppedImage!.length()} bytes');
          final inputImage = InputImage.fromFilePath(croppedImage.path);
          final barcodes = await _barcodeScanner.processImage(inputImage);

          String text = 'Barcodes found: ${barcodes.length}\n\n';

          for (final barcode in barcodes) {
            text += 'Barcode: ${barcode.displayValue}\n\n';
          }
          print("Barcode text: $text");
        }
      }
    } catch (e) {
      print("Error on scanning: ${e.toString()}");
    } finally {
      _barcodeScanner.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = ref.watch(imageProvider).image;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Barcode'),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              constrained: true,
              scaleEnabled: true,
              panEnabled: true,
              child: image != null
                  ? Image.file(
                      File(image.path),
                      fit: BoxFit.fill,
                      frameBuilder: (BuildContext context, Widget child,
                          int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    )
                  : const Center(child: Text("Image not found")),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (details) {
                final localPosition = details.localPosition;
                setState(() {
                  _startDrag = localPosition;
                  _currentDrag = localPosition;
                });
              },
              onPanUpdate: (details) {
                final localPosition = details.localPosition;
                setState(() {
                  _currentDrag = localPosition;
                });
              },
              onPanEnd: (details) async {
                _processImage(image);
              },
              child: CustomPaint(
                painter: SelectionPainter(
                  startDrag: _startDrag,
                  currentDrag: _currentDrag,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionPainter extends CustomPainter {
  final Offset? startDrag;
  final Offset? currentDrag;

  SelectionPainter({
    required this.startDrag,
    required this.currentDrag,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    if (startDrag != null && currentDrag != null) {
      Rect rect = Rect.fromPoints(startDrag!, currentDrag!);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
