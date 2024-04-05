import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera_view.dart';
import 'provider/barcode_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Open Packages",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () => {
                    ref.read(imageProvider).addImage(),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraView()))
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
