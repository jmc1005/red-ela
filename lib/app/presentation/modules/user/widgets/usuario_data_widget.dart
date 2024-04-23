import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/usuario_controller.dart';

class UsuarioDataWidget extends StatefulWidget with ValidatorMixin {
  UsuarioDataWidget({
    super.key,
    required this.usuarioController,
  });

  final UsuarioController usuarioController;

  @override
  State<UsuarioDataWidget> createState() => _UsuarioDataWidgetState();
}

class _UsuarioDataWidgetState extends State<UsuarioDataWidget> {
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuarioController = widget.usuarioController;
    final usuarioModel = usuarioController.state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 3,
                  color: Color(0x33000000),
                  offset: Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16,
              ),
              child: Column(
                children: [
                  TextFormWidget(
                    initialValue: usuarioModel?.nombre ?? '',
                    label: language.nombre,
                    keyboardType: TextInputType.text,
                    validator: (text) => widget.emailValidator(text, language),
                    onChanged: (text) {
                      usuarioController.onChangeValueEmail(text);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormWidget(
                    initialValue: usuarioModel?.apellido1 ?? '',
                    label: language.apellido,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      usuarioController.onChangeValueApellido1(text);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormWidget(
                    initialValue: usuarioModel?.apellido2 ?? '',
                    label: language.apellido,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      usuarioController.onChangeValueApellido2(text);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormWidget(
                    initialValue: usuarioModel?.email ?? '',
                    label: language.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) => widget.emailValidator(text, language),
                    onChanged: (text) {
                      usuarioController.onChangeValueEmail(text);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
