import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/gestor_casos_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/cita_controller.dart';

class DropdownPacientesWidget extends StatefulWidget {
  const DropdownPacientesWidget({
    super.key,
    required this.citaController,
    required this.label,
    required this.uidPaciente,
  });

  final CitaController citaController;
  final String label;
  final String? uidPaciente;

  @override
  State<DropdownPacientesWidget> createState() =>
      _DropdownPacientesWidgetState();
}

class _DropdownPacientesWidgetState extends State<DropdownPacientesWidget> {
  UsuarioModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    final usuarioRepo = Provider.of<UsuarioRepo>(context);
    final gestorRepo = Provider.of<GestorCasosRepo>(context);
    final language = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: getData(gestorRepo, usuarioRepo, widget.uidPaciente),
      builder: (_, snapshot) {
        return snapshot.hasData
            ? pacienteWidget(snapshot.data!, language)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<UsuarioModel>> getData(
    GestorCasosRepo gestorRepo,
    UsuarioRepo usuarioRepo,
    String? uidPaciente,
  ) async {
    selectedItem = null;
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

      if (uidPaciente != null && uidPaciente.isNotEmpty) {
        selectedItem = list.where((p) => p.uid == uidPaciente).first;
      }
    }

    return Future.value(list);
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    UsuarioModel item,
    bool isSelected,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
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
    if (value != null) {
      widget.citaController.onChangeUidPaciente(value.uid);
    }
  }

  Widget pacienteWidget(List<UsuarioModel> list, AppLocalizations language) {
    return selectedItem != null
        ? SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: TextFormWidget(
              label: language.paciente,
              readOnly: true,
              keyboardType: TextInputType.text,
              initialValue: selectedItem!.nombreCompleto,
            ),
          )
        : DropdownSearch<UsuarioModel>(
            items: list,
            itemAsString: (item) => item.nombreCompleto,
            compareFn: (i, s) => i.uid == s.uid,
            selectedItem: selectedItem,
            filterFn: (item, filter) {
              if (filter.isEmpty) {
                return true;
              }

              return item.nombreCompleto
                  .toLowerCase()
                  .contains(filter.toLowerCase());
            },
            popupProps: PopupPropsMultiSelection.modalBottomSheet(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
              itemBuilder: _customPopupItemBuilder,
            ),
            onChanged: selectedItem != null ? null : onChanged,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration:
                  InputDecoration(labelText: widget.label),
            ),
            enabled: selectedItem == null,
          );
  }
}
