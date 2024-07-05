import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/hospital/hospital_model.dart';
import '../../../../domain/repository/hospital_repo.dart';
import '../../../global/widgets/sin_datos_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class DropdownHospitalesWidget extends StatefulWidget {
  const DropdownHospitalesWidget({
    super.key,
    required this.usuarioController,
    required this.label,
    this.uuidHospital,
  });

  final String label;
  final UsuarioController usuarioController;
  final String? uuidHospital;

  @override
  State<DropdownHospitalesWidget> createState() =>
      _DropdownHospitalesWidgetState();
}

class _DropdownHospitalesWidgetState extends State<DropdownHospitalesWidget> {
  HospitalModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    final HospitalRepo hospitalRepo = context.read();

    return FutureBuilder(
      future: getData(hospitalRepo, widget.uuidHospital),
      builder: (_, snapshot) {
        return snapshot.hasData
            ? DropdownSearch<HospitalModel>(
                items: snapshot.data!,
                itemAsString: (item) => item.hospital,
                compareFn: (i, s) => i.uuid == s.uuid,
                filterFn: (item, filter) {
                  if (filter.isEmpty) {
                    return true;
                  }
                  return item.hospital
                      .toLowerCase()
                      .contains(filter.toLowerCase());
                },
                selectedItem: selectedItem,
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  isFilterOnline: true,
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: _customPopupItemBuilder,
                ),
                onChanged: onChanged,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration:
                      InputDecoration(labelText: widget.label),
                ),
              )
            : const SinDatosWidget();
      },
    );
  }

  Future<List<HospitalModel>> getData(
    HospitalRepo hospitalRepo,
    String? uuidHospital,
  ) async {
    var list = <HospitalModel>[];

    final response = await hospitalRepo.getHospitales();

    response.when(
      (success) => list = success,
      (error) => debugPrint(error),
    );

    if (uuidHospital != null) {
      selectedItem = list.where((h) => h.uuid == uuidHospital).first;
    }

    return Future.value(list);
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    HospitalModel item,
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
        title: Text(
          item.hospital,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void onChanged(HospitalModel? value) {
    if (value != null) {
      widget.usuarioController.onChangeHospital(value.uuid);
    }
  }
}
