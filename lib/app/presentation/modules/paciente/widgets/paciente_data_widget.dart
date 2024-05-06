import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class PacienteDataWidget extends StatefulWidget with ValidatorMixin {
  PacienteDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacienteDataWidget> createState() => _PacienteDataWidgetState();
}

class _PacienteDataWidgetState extends State<PacienteDataWidget> {
  final dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: TextFormWidget(
                  label: language.tratamiento,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => controller.onChangeTratamiento(text),
                  validator: (value) => widget.textValidator(
                    value,
                    language,
                  ),
                ),
              ),
              Flexible(
                child: TextFormWidget(
                  label: language.inicio,
                  keyboardType: TextInputType.text,
                  onChanged: (text) => controller.onChangeValueInicio(text),
                  validator: (value) => widget.textValidator(
                    value,
                    language,
                  ),
                ),
              )
            ],
          ),
          TextFormWidget(
            key: const Key('kFechaDiagnostico'),
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
            onTap: () => controller.openDatePickerFechaDiagnostico(
              context,
              dateInput,
            ),
          ),
        ],
      ),
    );
  }
}
