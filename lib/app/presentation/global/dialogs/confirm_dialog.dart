import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = '',
  required List<Widget> actions,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.white.withOpacity(0.4), // cambiar la sombra
    barrierDismissible: false, // evitar cerrar popup al pulsar fuera del dialog
    builder: (context) => _DialogContent(
      title: title,
      actions: actions,
    ),
  );

  return result ?? false;
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({
    required this.title,
    required this.actions,
  });

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(10),
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // cambiar el borde radius
        actionsAlignment: MainAxisAlignment.center,
        actions: actions,
      ),
      onPopInvoked: (didPop) => false,
    );
  }
}
