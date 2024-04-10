import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/appThemes/colors.dart';

class AdaptiveAlerts {
  showAlert({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelText,
    required String acceptText,
    required Function() accept,
    required Function() cancel,
  }) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: cancel,
              child: Text(
                cancelText,
                style: const TextStyle(color: AppColors.primaryBlue),
              ),
            ),
            TextButton(
              onPressed: accept,
              child: Text(
                acceptText,
                style: const TextStyle(color: AppColors.primaryOrange),
              ),
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: cancel,
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: accept,
              child: Text(acceptText),
            ),
          ],
        ),
      );
    }
  }
}
