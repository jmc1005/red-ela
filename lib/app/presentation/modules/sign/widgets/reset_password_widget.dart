import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../global/dialogs/reset_password_dialog.dart';
import '../../../global/widgets/text_gesture_detector_widget.dart';
import '../controllers/sign_controller.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key, required this.signController});

  final SignController signController;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final language = AppLocalizations.of(context)!;

    final List<Widget> actions = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConfig.cancelar,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          language.cancelar,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      OutlinedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            signController.resetPassword(context: context, language: language);
            Navigator.pop(context, true);
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConfig.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          language.aceptar,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ];

    return TextGestureDetectorWidget(
      onTap: () => showResetPasswordDialog(
        context,
        signController: signController,
        actions: actions,
        formKey: formKey,
      ),
      tapString: language.olvido_password,
    );
  }
}
