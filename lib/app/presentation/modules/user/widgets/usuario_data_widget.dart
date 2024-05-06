import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../paciente/widgets/paciente_data_widget.dart';
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
  final _formKey = GlobalKey<FormState>();
  final dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuarioController = widget.usuarioController;
    final usuarioModel = usuarioController!.state!.usuario;

    final tipo = usuarioModel.rol != null && usuarioModel.rol!.isNotEmpty
        ? usuarioModel.rol
        : UsuarioTipo.paciente.value;

    if (usuarioModel.fechaNacimiento != null &&
        usuarioModel.fechaNacimiento!.isNotEmpty) {
      dateInput.text = usuarioModel.fechaNacimiento!;
    } else {
      dateInput.text = '';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormWidget(
                initialValue: usuarioModel.nombre ?? '',
                label: language.nombre,
                keyboardType: TextInputType.text,
                onChanged: (text) => usuarioController.onChangeValueNombre(
                  text,
                ),
              ),
              const SizedBox(height: 12),
              TextFormWidget(
                initialValue: usuarioModel.apellido1 ?? '',
                label: language.apellido,
                keyboardType: TextInputType.text,
                onChanged: (text) => usuarioController.onChangeValueApellido1(
                  text,
                ),
              ),
              const SizedBox(height: 12),
              TextFormWidget(
                initialValue: usuarioModel.apellido2 ?? '',
                label: language.apellido2,
                keyboardType: TextInputType.text,
                onChanged: (text) => usuarioController.onChangeValueApellido2(
                  text,
                ),
              ),
              const SizedBox(height: 12),
              TextFormWidget(
                initialValue: usuarioModel.email,
                label: language.email,
                keyboardType: TextInputType.emailAddress,
                validator: (text) => widget.emailValidator(text, language),
                onChanged: (text) => usuarioController.onChangeValueEmail(
                  text,
                ),
              ),
              const SizedBox(height: 12),
              TextFormWidget(
                key: const Key('kFechaNacimiento'),
                controller: dateInput,
                label: language.fecha_diagnostico,
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
              const SizedBox(height: 12),
              DropdownButtonFormField(
                items: usuarioController.typeList,
                value: tipo,
                decoration: InputDecoration(
                  label: Text(language.tipo_usuario),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      usuarioController.onChangeValueTipo(value);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              if (tipo == UsuarioTipo.paciente.value)
                PacienteDataWidget(usuarioController: usuarioController),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    usuarioController.update(context, language);
                  }
                },
                child: Text(
                  language.guardar,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
