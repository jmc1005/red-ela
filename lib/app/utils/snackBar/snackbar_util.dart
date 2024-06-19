import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarUtils {
  final BuildContext context;
  final String message;

  SnackBarUtils({
    required this.context,
    required this.message,
  });

  void showSuccess() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
      dismissType: DismissType.onSwipe,
      // dismissDirection: [DismissDirection.endToStart],
      // snackBarPosition: SnackBarPosition.top,
    );
  }

  void showError() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
      dismissType: DismissType.onSwipe,
      // dismissDirection: [DismissDirection.endToStart],
      // snackBarPosition: SnackBarPosition.top,
    );
  }

  void showWarning() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: message),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.endToStart],
      snackBarPosition: SnackBarPosition.bottom,
    );
  }
}
