import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/appThemes/colors.dart';
import 'provider/barcode_provider.dart';
import 'widget/image_selected_view_widget.dart';

class ScannerScreen extends ConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text(
          "Open Packages",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () => {
                    ref.read(scanningProvider).addImage(),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ImageSelectedViewWidget()))
                  },
              icon: const Icon(
                Icons.qr_code_scanner_outlined,
                size: 24,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
