import 'package:flutter/material.dart';

class RouteErrorWidget extends StatelessWidget {
  final String? settings;
  const RouteErrorWidget({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
        centerTitle: true,
      ), // AppBar
      body: Center(
        child: Text(
          "Page Not Found $settings".toUpperCase(),
        ),
      ),
    );
  }
}
