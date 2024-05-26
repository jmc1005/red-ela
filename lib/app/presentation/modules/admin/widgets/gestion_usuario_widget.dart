import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/color_config.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';
import '../../user/views/usuarios_view.dart';
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
        label: language.gestores_casos,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsuariosView(
                rol: UsuarioTipo.gestorCasos.value,
              ),
            ),
          );
        },
      ),
      ItemWidget(
        label: language.pacientes,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsuariosView(
                rol: UsuarioTipo.paciente.value,
              ),
            ),
          );
        },
      ),
      ItemWidget(
        label: language.cuidadores,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsuariosView(
                rol: UsuarioTipo.cuidador.value,
              ),
            ),
          );
        },
      ),
    ];

    return GestionWidget(children: children);
  }
}
