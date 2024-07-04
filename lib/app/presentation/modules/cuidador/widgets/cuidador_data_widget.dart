import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class CuidadorDataWidget extends StatefulWidget with ValidatorMixin {
  CuidadorDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<CuidadorDataWidget> createState() => _CuidadorDataWidgetState();
}

class _CuidadorDataWidgetState extends State<CuidadorDataWidget> {
  final relacionFocus = FocusNode();
  final textRelacionController = TextEditingController();

  void _setCuidadorVacio() {
    const cuidadorModel = CuidadorModel(
      usuarioUid: '',
      pacientes: [],
    );

    if (widget.usuarioController.state!.cuidador == null) {
      widget.usuarioController.cuidador = cuidadorModel;
    }
  }

  Future<Result<CuidadorModel, dynamic>> _getFutureCuidador() async {
    final usuarioController = widget.usuarioController;
    final uid = usuarioController.state!.usuario.uid;
    final cuidadorRepo = usuarioController.cuidadorController.cuidadorRepo;

    return cuidadorRepo.getCuidadorByUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;

    final language = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: _getFutureCuidador(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          data.when(
            (success) {
              if (controller.state!.cuidador == null) {
                controller.cuidador = success;
              }

              textRelacionController.text = success.relacion;
              controller.cuidador = success;
            },
            (error) => debugPrint(error),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          _setCuidadorVacio();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              TextFormWidget(
                label: language.relacion,
                keyboardType: TextInputType.text,
                focusNode: relacionFocus,
                controller: textRelacionController,
                onChanged: (text) => controller.onChangeRelacion(text),
                validator: (value) => widget.textValidator(
                  value,
                  language,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
