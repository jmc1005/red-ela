import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/usuario_controller.dart';

class UsuarioDataWidget extends StatefulWidget with ValidatorMixin {
  UsuarioDataWidget({
    super.key,
    this.usuarioController,
  });

  final UsuarioController? usuarioController;

  @override
  State<UsuarioDataWidget> createState() => _UsuarioDataWidgetState();
}

class _UsuarioDataWidgetState extends State<UsuarioDataWidget> {
  final dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuarioController = widget.usuarioController;
    final usuario = usuarioController!.state!.usuario;

    if (usuario.fechaNacimiento != null &&
        usuario.fechaNacimiento!.isNotEmpty) {
      dateInput.text = usuario.fechaNacimiento!;
    }

    return Column(
      children: [
        TextFormWidget(
          initialValue: usuario.nombre ?? '',
          label: language.nombre,
          keyboardType: TextInputType.text,
          onChanged: (text) => usuarioController.onChangeValueNombre(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.apellido1 ?? '',
          label: language.apellido,
          keyboardType: TextInputType.text,
          onChanged: (text) => usuarioController.onChangeValueApellido1(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.apellido2 ?? '',
          label: language.apellido2,
          keyboardType: TextInputType.text,
          onChanged: (text) => usuarioController.onChangeValueApellido2(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.email,
          label: language.email,
          keyboardType: TextInputType.emailAddress,
          validator: (text) => widget.emailValidator(text, language),
          onChanged: (text) => usuarioController.onChangeValueEmail(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          key: const Key('kFechaNacimiento'),
          controller: dateInput,
          label: language.fecha_nacimiento,
          keyboardType: TextInputType.datetime,
          suffixIcon: const Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.calendar_today,
            ),
          ),
          onTap: () => usuarioController.openDatePicker(
            context,
            dateInput,
          ),
        ),
      ],
    );
  }
}
