import 'package:barcode_genrator/src/scanner_screen/scanner_screen.dart';
import 'package:flutter/material.dart';

import '../../src/home/home_screen.dart';
import '../routes_widgets/error_route_widget.dart';
import 'routes_constant.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case RoutesConst.initalRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case RoutesConst.scannerScreen:
        return MaterialPageRoute(
          builder: (context) => const ScannerScreen(),
        );

      default:
        return errorRoute(settings: settings.name);
    }
  }

  static Route<dynamic> errorRoute({required String? settings}) {
    return MaterialPageRoute(builder: (context) {
      return RouteErrorWidget(
        settings: settings,
      );
    });
  }
}
