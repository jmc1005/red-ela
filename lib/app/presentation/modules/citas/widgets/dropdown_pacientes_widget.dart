import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/gestor_casos_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../controllers/cita_controller.dart';

class DropdownPacientesWidget extends StatelessWidget {
  const DropdownPacientesWidget({
    super.key,
    required this.citaController,
  });

  final CitaController citaController;

  @override
  Widget build(BuildContext context) {
    final usuarioRepo = Provider.of<UsuarioRepo>(context);
    final gestorRepo = Provider.of<GestorCasosRepo>(context);

    return DropdownSearch<UsuarioModel>(
      asyncItems: (filter) => getData(gestorRepo, usuarioRepo, filter),
      itemAsString: (item) => item.nombreCompleto,
      compareFn: (i, s) => i.uid == s.uid,
      popupProps: PopupPropsMultiSelection.modalBottomSheet(
        isFilterOnline: true,
        showSelectedItems: true,
        showSearchBox: true,
        itemBuilder: _customPopupItemBuilder,
      ),
      onChanged: onChanged,
    );
  }

  Future<List<UsuarioModel>> getData(
    GestorCasosRepo gestorRepo,
    UsuarioRepo usuarioRepo,
    String filter,
  ) async {
    final list = <UsuarioModel>[];

    final responseGestorCasos = await gestorRepo.getGestorCasos();
    var pacientes = <String>[];

    responseGestorCasos.when(
      (success) => pacientes = success.pacientes ?? <String>[],
      (error) => debugPrint(error),
    );

    if (pacientes.isNotEmpty) {
      for (final p in pacientes) {
        final response = await usuarioRepo.getUsuarioByUid(uid: p);

        response.when(
          (success) => list.add(success),
          (error) => debugPrint(error),
        );
      }
    }

    return filter.isNotEmpty
        ? list
            .where(
              (u) =>
                  u.nombreCompleto.toLowerCase().contains(filter.toLowerCase()),
            )
            .toList()
        : list;
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    UsuarioModel item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: ColorConfig.primary),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.nombreCompleto),
      ),
    );
  }

  void onChanged(UsuarioModel? value) {
    if (value != null) {}
  }
}
