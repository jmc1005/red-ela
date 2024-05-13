import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/sign_controller.dart';

class SignUpWidget extends StatefulWidget with ValidatorMixin {
  SignUpWidget({
    super.key,
    required this.signController,
    required this.password,
    required this.obscureConfirmPassword,
    required this.validConfirmPassword,
  });

  final SignController signController;
  final String password;
  final bool obscureConfirmPassword;
  final bool validConfirmPassword;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final confirmPassController = TextEditingController();
  final confirmPassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final String tipo = UsuarioTipo.paciente.value;
    final signController = widget.signController;
    var obscureConfirmPassword = widget.obscureConfirmPassword;
    var validConfirmPassword = widget.validConfirmPassword;
    final password = widget.password;

    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormWidget(
          controller: confirmPassController,
          focusNode: confirmPassFocusNode,
          label: language.confirmar_password,
          keyboardType: TextInputType.text,
          validator: (value) {
            final validPassword = widget.passwordValidator(
              value,
              language,
            );

            if (validPassword == null) {
              validConfirmPassword = password == confirmPassController.text;

              if (!validConfirmPassword) {
                return language.password_no_coincide;
              }
            }

            return validPassword;
          },
          onChanged: (text) {
            signController.onConfirmPasswordChanged(text);
          },
          obscureText: obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(!obscureConfirmPassword
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;

                signController.onVisibilityConfirmPasswordChanged(
                  obscureConfirmPassword,
                );
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField(
          items: signController.typeList,
          value: tipo,
          decoration: InputDecoration(
            label: Text(language.tipo_usuario),
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                signController.onChangeValueTipo(value);
              });
            }
          },
        ),
      ],
    );
  }
}
