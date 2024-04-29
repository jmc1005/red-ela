import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import 'gestion_widget.dart';

class GestionUsuarioWidget extends StatelessWidget {
  const GestionUsuarioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    final List<Widget> children = [
      CabeceraWidget(
        label: language.gestion_usuarios,
        color: ColorConfig.cabeceraAdmin,
      ),
      ItemWidget(
        label: language.usuarios,
        onTap: () {
          navigateTo(Routes.userList, context);
        },
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
