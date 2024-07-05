import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/tratamiento/tratamiento_model.dart';

import '../../../../domain/repository/tratamiento_repo.dart';
import '../../../global/widgets/sin_datos_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class DropdownTratamientosWidget extends StatefulWidget {
  const DropdownTratamientosWidget({
    super.key,
    required this.usuarioController,
    required this.label,
    this.uuidTratamiento,
  });

  final String label;
  final UsuarioController usuarioController;
  final String? uuidTratamiento;

  @override
  State<DropdownTratamientosWidget> createState() =>
      _DropdownTratamientosWidgetState();
}

class _DropdownTratamientosWidgetState
    extends State<DropdownTratamientosWidget> {
  TratamientoModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    final tratamientoRepo = Provider.of<TratamientoRepo>(context);

    return FutureBuilder(
      future: getData(tratamientoRepo, widget.uuidTratamiento),
      builder: (_, snapshot) {
        return snapshot.hasData
            ? DropdownSearch<TratamientoModel>(
                items: snapshot.data!,
                filterFn: (item, filter) {
                  if (filter.isEmpty) {
                    return true;
                  }

                  return item.tratamiento
                      .toLowerCase()
                      .contains(filter.toLowerCase());
                },
                itemAsString: (item) => item.tratamiento,
                compareFn: (i, s) => i.uuid == s.uuid,
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  isFilterOnline: true,
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: _customPopupItemBuilder,
                ),
                onChanged: onChanged,
                selectedItem: selectedItem,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration:
                      InputDecoration(labelText: widget.label),
                ),
              )
            : const SinDatosWidget();
      },
    );
  }

  Future<List<TratamientoModel>> getData(
    TratamientoRepo tratamientoRepo,
    String? uuidTratamiento,
  ) async {
    var list = <TratamientoModel>[];

    final response = await tratamientoRepo.getTratamientos();

    response.when(
      (success) => list = success,
      (error) => debugPrint(error),
    );

    if (uuidTratamiento != null) {
      selectedItem = list.where((h) => h.uuid == uuidTratamiento).first;
    }

    return Future.value(list);
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    TratamientoModel item,
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
        title: Text(item.tratamiento),
      ),
    );
  }

  void onChanged(TratamientoModel? value) {
    if (value != null) {
      widget.usuarioController.onChangeTratamiento(value.uuid);
    }
  }
}
