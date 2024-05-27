import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';
import '../../rol/views/roles_view.dart';
import '../../user/views/usuarios_view.dart';
import 'gestion_widget.dart';

class GestionRolWidget extends StatelessWidget {
  const GestionRolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    final List<Widget> children = [
      CabeceraWidget(
        label: language.gestion_roles,
        color: ColorConfig.cabeceraAdmin,
      ),
      ItemWidget(
        label: language.roles,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RolesView(),
            ),
          );
        },
      ),
    ];

    return GestionWidget(children: children);
  }
}
