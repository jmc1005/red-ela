import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../user/controllers/usuario_controller.dart';
import 'dropdown_hospitales_widget.dart';

class GestorCasosDataWidget extends StatefulWidget with ValidatorMixin {
  GestorCasosDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<GestorCasosDataWidget> createState() => _GestorCasosDataWidgetState();
}

class _GestorCasosDataWidgetState extends State<GestorCasosDataWidget> {
  String? hospital;

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
          String? uuidHospital;

          if (snapshot.hasData) {
            final data = snapshot.data!;

            data.when(
              (success) {
                gestorCasosModel = success;
                controller.onChangeHospital(success.hospital ?? '');
                if (success.hospital != null) {
                  uuidHospital = success.hospital;
                }
              },
              (error) => debugPrint(error),
            );
          }

          return Container(
            width: MediaQuery.of(context).size.width / 1.1,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownHospitalesWidget(
              usuarioController: controller,
              label: language.hospital,
              uuidHospital: uuidHospital,
            ),
          );
        });
  }
}
