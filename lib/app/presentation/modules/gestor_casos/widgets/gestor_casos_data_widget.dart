import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class GestorCasosDataWidget extends StatefulWidget with ValidatorMixin {
  GestorCasosDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<GestorCasosDataWidget> createState() => _GestorCasosDataWidgetState();
}

class _GestorCasosDataWidgetState extends State<GestorCasosDataWidget> {
  final textHospitalController = TextEditingController();

  GestorCasosModel gestorCasosModel = const GestorCasosModel(
    usuarioUid: '',
    hospital: '',
    pacientes: [],
  );

  Future<Result<GestorCasosModel, dynamic>> _getFutureGestorCasos() async {
    return widget.usuarioController.gestorCasosController.gestorCasosRepo
        .getGestorCasos();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;
    controller.gestorCasos = gestorCasosModel;

    return FutureBuilder(
        future: _getFutureGestorCasos(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            data.when(
              (success) {
                gestorCasosModel = success;
                textHospitalController.text = success.hospital ?? '';
              },
              (error) => debugPrint(error),
            );
          }

          return Container(
            width: MediaQuery.of(context).size.width / 1.4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormWidget(
              label: language.hospital,
              controller: textHospitalController,
              keyboardType: TextInputType.text,
              onChanged: (text) => controller.onChangeHospital(text),
              validator: (value) => widget.textValidator(value, language),
            ),
          );
        });
  }
}
