import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/validators/validator_mixin.dart';

import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class PacienteGestorCasosWidget extends StatefulWidget with ValidatorMixin {
  PacienteGestorCasosWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacienteGestorCasosWidget> createState() =>
      _PacienteGestorCasosWidgetState();
}

class _PacienteGestorCasosWidgetState extends State<PacienteGestorCasosWidget> {
  late final Future<Result<PacienteModel, dynamic>> futurePaciente;
  late final UsuarioModel? usuarioCuidador;

  final dateInput = TextEditingController();

  var headerStyle = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          FutureBuilder(
            future: null,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    TextFormWidget(
                      label: '${language.nombre} ${language.gestor_casos}',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.apellido} ${language.gestor_casos}',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.apellido2} ${language.gestor_casos}',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.hospital} ${language.gestor_casos}',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.telefono,
                      keyboardType: TextInputType.phone,
                      prefixText: '+34 ',
                      readOnly: true,
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    TextFormWidget(
                      label: language.nombre,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido2,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.hospital,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.telefono,
                      keyboardType: TextInputType.phone,
                      prefixText: '+34 ',
                      readOnly: true,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
