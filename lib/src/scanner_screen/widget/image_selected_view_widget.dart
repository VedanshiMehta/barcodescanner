import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../../core/constants/appThemes/colors.dart';
import '../provider/barcode_provider.dart';

class ImageSelectedViewWidget extends ConsumerStatefulWidget {
  const ImageSelectedViewWidget({super.key});

  @override
  ConsumerState<ImageSelectedViewWidget> createState() => CameraViewState();
}

class CameraViewState extends ConsumerState<ImageSelectedViewWidget> {
  Offset? _startDrag;
  Offset? _endDrag;
  Offset? _cropStartDrag;
  Offset? _cropEndDrag;

  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var scannerProvider = ref.watch(scanningProvider);
    var barcodeText = scannerProvider.barcodeText;
    var appbarText = scannerProvider.appbarText;
    log("Barcode Text: $barcodeText");
    var size = MediaQuery.of(context).size;
    double width = size.width;
    var image = ref.watch(scanningProvider).image;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: Text(
          appbarText,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              key: _imageKey,
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
                  _endDrag = localPosition;
                });
                RenderBox renderBox =
                    _imageKey.currentContext?.findRenderObject() as RenderBox;

                _cropStartDrag =
                    renderBox.globalToLocal(details.globalPosition);
              },
              onPanUpdate: (details) {
                final localPosition = details.localPosition;
                setState(() {
                  _endDrag = localPosition;
                });
                RenderBox renderBox =
                    _imageKey.currentContext?.findRenderObject() as RenderBox;
                _cropEndDrag = renderBox.globalToLocal(details.globalPosition);
              },
              onPanEnd: (details) async {
                ref.read(scanningProvider).scanBarcode(
                    croppedStart: _cropStartDrag,
                    croppedEnd: _cropEndDrag,
                    width: width,
                    file: File(image?.path ?? ""));
              },
              child: CustomPaint(
                painter: SelectionPainter(
                  startDrag: _startDrag,
                  currentDrag: _endDrag,
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

class MyWidget extends StatelessWidget {
  final img.Image? filePath;
  const MyWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: filePath != null
          ? Image.memory(
              img.encodePng(filePath!),
              fit: BoxFit.contain,
            )
          : const Text("No Image Found"),
    );
  }
}
