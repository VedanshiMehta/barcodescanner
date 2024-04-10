import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/appThemes/colors.dart';
import '../scanner_screen/provider/barcode_provider.dart';
import '../scanner_screen/scanner_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
                            builder: (context) => const ScannerScreen()))
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
