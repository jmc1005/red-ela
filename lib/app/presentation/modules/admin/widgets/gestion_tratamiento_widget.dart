import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';
import '../../tratamiento/views/tratamientos_view.dart';
import 'gestion_widget.dart';

class GestionTratamientoWidget extends StatelessWidget {
  const GestionTratamientoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    final List<Widget> children = [
      CabeceraWidget(
        label: language.gestion_tratamientos,
        color: ColorConfig.cabeceraAdmin,
      ),
      ItemWidget(
        label: language.tratamientos,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TratamientosView(),
            ),
          );
        },
      ),
    ];

    return GestionWidget(children: children);
  }
}
