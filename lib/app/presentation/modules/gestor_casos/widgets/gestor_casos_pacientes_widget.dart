import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';
import '../../user/widgets/usuario_row_widget.dart';

class GestorCasosPacientesWidget extends StatefulWidget with ValidatorMixin {
  GestorCasosPacientesWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<GestorCasosPacientesWidget> createState() =>
      _GestorCasosPacientesWidgetState();
}

class _GestorCasosPacientesWidgetState
    extends State<GestorCasosPacientesWidget> {
  List<UsuarioModel> _usuarios = [];
  final _usuariosStream = StreamController<List<UsuarioModel>>();
  final _textSearchController = TextEditingController();

  @override
  void initState() {
    _loadPacientes();
    super.initState();
  }

  Future<void> _loadPacientes() async {
    final usuarioRepo = widget.usuarioController.usuarioRepo;
    final gestorCasosRepo =
        widget.usuarioController.gestorCasosController.gestorCasosRepo;
    final responseGestorCasos = await gestorCasosRepo.getGestorCasos();

    responseGestorCasos.when(
      (success) async => _loadPacientesByGestorCasos(usuarioRepo, success),
      (error) => debugPrint(error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height / 1.3,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height / 1.3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          TextFormWidget(
            label: language.buscar,
            keyboardType: TextInputType.text,
            controller: _textSearchController,
            onChanged: (value) {
              _loadPacientes();
            },
            suffixIcon: const Icon(Icons.search),
          ),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: _usuariosStream.stream,
            builder: (_, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (_, index) {
                        final usuarioModel = snapshot.data![index];

                        return UsuarioRowWidget(
                          usuarioModel: usuarioModel,
                        );
                      },
                      itemCount: snapshot.data!.length,
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(
            height: 24,
          )
        ]),
      ),
    );
  }

  Future<void> _loadPacientesByGestorCasos(
    UsuarioRepo repo,
    GestorCasosModel gestorCasosModel,
  ) async {
    if (gestorCasosModel.pacientes != null &&
        gestorCasosModel.pacientes!.isNotEmpty) {
      final search = _textSearchController.text.toLowerCase();

      for (final paciente in gestorCasosModel.pacientes!) {
        final pacienteResponse = await repo.getUsuarioByUid(uid: paciente);

        pacienteResponse.when(
          (success) => _usuarios.add(success),
          (error) => debugPrint(error),
        );
      }

      if (search.isNotEmpty) {
        _usuarios = _usuarios
            .where((u) =>
                u.nombreCompleto.trim().toLowerCase().contains(search.trim()))
            .toList();
      }

      _usuariosStream.add(_usuarios);
    }
  }
}
