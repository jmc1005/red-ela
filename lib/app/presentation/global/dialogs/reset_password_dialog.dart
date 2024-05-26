import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/color_config.dart';
import '../../../utils/validators/validator_mixin.dart';
import '../../modules/sign/controllers/sign_controller.dart';
import '../widgets/text_form_widget.dart';

Future<bool> showResetPasswordDialog(
  BuildContext context, {
  required SignController signController,
  required List<Widget> actions,
  required GlobalKey formKey,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.white.withOpacity(0.4), // cambiar la sombra
    barrierDismissible: false, // evitar cerrar popup al pulsar fuera del dialog
    builder: (context) => _DialogContent(
      signController: signController,
      actions: actions,
      formKey: formKey,
    ),
  );

  return result ?? false;
}

class _DialogContent extends StatefulWidget with ValidatorMixin {
  _DialogContent({
    required this.signController,
    required this.actions,
    required this.formKey,
  });

  final SignController signController;
  final List<Widget> actions;
  final GlobalKey formKey;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return PopScope(
      child: AlertDialog(
        backgroundColor: ColorConfig.dialogBackground,
        content: Form(
          key: widget.formKey,
          child: TextFormWidget(
            controller: emailController,
            focusNode: emailFocusNode,
            label: language.email,
            keyboardType: TextInputType.emailAddress,
            validator: (text) => widget.emailValidator(
              text,
              language,
            ),
            onChanged: (text) {
              widget.signController.onEmailChanged(text);
            },
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // cambiar el borde radius
        actionsAlignment: MainAxisAlignment.center,
        actions: widget.actions,
      ),
      onPopInvoked: (didPop) => false,
    );
  }
}
