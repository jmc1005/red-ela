import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';

import '../../hospital/views/hospitales_view.dart';
import 'gestion_widget.dart';

class GestionHospitalWidget extends StatelessWidget {
  const GestionHospitalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    final List<Widget> children = [
      CabeceraWidget(
        label: language.gestion_hospitales,
        color: ColorConfig.cabeceraAdmin,
      ),
      ItemWidget(
        label: language.hospitales,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HospitalesView(),
            ),
          );
        },
      ),
    ];

    return GestionWidget(children: children);
  }
}
