import 'package:flutter/material.dart';
import 'package:red_ela/app/config/color_config.dart';
import 'package:red_ela/app/presentation/global/widgets/cabecera_widget.dart';
import 'package:red_ela/app/presentation/global/widgets/item_widget.dart';
import 'package:red_ela/app/presentation/modules/admin/widgets/gestion_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GestionUsuarioWidget extends StatelessWidget {
  const GestionUsuarioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    List<Widget> children = [
      CabeceraWidget(
        label: language.gestion_usuarios,
        color: ColorConfig.cabeceraAdmin,
      ),
      ItemWidget(
        label: language.usuarios,
        onTap: () {},
      ),
      ItemWidget(
        label: language.roles,
        onTap: () {},
      ),
      ItemWidget(
        label: language.tipos,
        onTap: () {},
      ),
    ];

    return GestionWidget(children: children);
  }
}
