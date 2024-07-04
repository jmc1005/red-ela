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

  void _setGestorCasosVacio() {
    const gestorCasos = GestorCasosModel(
      usuarioUid: '',
      hospital: '',
      pacientes: [],
    );

    if (widget.usuarioController.state!.gestorCasos == null) {
      widget.usuarioController.gestorCasos = gestorCasos;
    }
  }

  Future<Result<GestorCasosModel, dynamic>> _getFutureGestorCasos() async {
    final usuarioController = widget.usuarioController;
    final uid = usuarioController.state!.usuario.uid;
    final gestorCasosRepo =
        usuarioController.gestorCasosController.gestorCasosRepo;

    return gestorCasosRepo.getGestorCasosByUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    return FutureBuilder(
        future: _getFutureGestorCasos(),
        builder: (_, snapshot) {
          String? uuidHospital;

          if (snapshot.hasData) {
            final data = snapshot.data!;

            data.when(
              (success) {
                if (controller.state!.gestorCasos == null) {
                  controller.gestorCasos = success;
                }

                if (success.hospital != null) {
                  uuidHospital = success.hospital;
                }
              },
              (error) => debugPrint(error),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            _setGestorCasosVacio();
          }

          return Container(
            width: MediaQuery.of(context).size.width / 1.1,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: DropdownHospitalesWidget(
                usuarioController: controller,
                label: language.hospital,
                uuidHospital: uuidHospital,
              ),
            ),
          );
        });
  }
}
