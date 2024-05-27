import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../config/color_config.dart';
import '../../../domain/models/rol/rol_model.dart';
import '../../../domain/repository/invitacion_repo.dart';
import '../../../domain/repository/rol_repo.dart';
import '../../../utils/validators/validator_mixin.dart';
import '../widgets/text_form_widget.dart';

Future<bool> showInvitarUsuarioDialog(
  BuildContext context, {
  required InvitacionRepo invitacionRepo,
  required String rol,
  required GlobalKey formKey,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.white.withOpacity(0.4), // cambiar la sombra
    barrierDismissible: false, // evitar cerrar popup al pulsar fuera del dialog
    builder: (context) => _DialogContent(
      invitacionRepo: invitacionRepo,
      rol: rol,
      formKey: formKey,
    ),
  );

  return result ?? false;
}

class _DialogContent extends StatefulWidget with ValidatorMixin {
  _DialogContent({
    required this.invitacionRepo,
    required this.rol,
    required this.formKey,
  });

  final InvitacionRepo invitacionRepo;
  final String rol;
  final GlobalKey formKey;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final phoneNumberController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();

  final rolController = TextEditingController();
  final rolFocusNode = FocusNode();

  late List<RolModel> roles = [];

  @override
  void initState() {
    _getRoles();
    super.initState();
  }

  Future<void> _getRoles() async {
    final rolRepo = Provider.of<RolRepo>(context);
    final rolesResponse = await rolRepo.getRoles();

    rolesResponse.when(
      (success) => roles = success,
      (error) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // enviar email

          // obtener rol
          widget.invitacionRepo.addInvitacion(
            telefono: phoneNumberController.text,
            rol: widget.rol,
          );
          Navigator.pop(context, true);
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

    return PopScope(
      child: AlertDialog(
        backgroundColor: ColorConfig.dialogBackground,
        content: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormWidget(
                controller: emailController,
                focusNode: emailFocusNode,
                label: language.email,
                keyboardType: TextInputType.emailAddress,
                validator: (text) => widget.emailValidator(
                  text,
                  language,
                ),
                onChanged: (text) {
                  emailController.text = text;
                },
              ),
              const SizedBox(height: 8),
              TextFormWidget(
                controller: phoneNumberController,
                focusNode: phoneNumberFocusNode,
                label: language.telefono,
                keyboardType: TextInputType.phone,
                prefixText: '+34 ',
                validator: (text) => widget.phoneValidator(
                  text,
                  language,
                ),
                onChanged: (text) {
                  phoneNumberController.text = text;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text(language.roles),
                ),
                items: [],
                onChanged: (value) {},
              ),
            ],
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
