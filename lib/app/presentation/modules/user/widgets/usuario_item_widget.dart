import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../global/dialogs/confirm_dialog.dart';

class UsuarioItemWidget extends StatelessWidget {
  const UsuarioItemWidget({
    super.key,
    required this.usuarioModel,
    this.onTap,
  });

  final UsuarioModel usuarioModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final nombre = usuarioModel.nombre ?? '';
    final apellido1 = usuarioModel.apellido1 ?? '';
    final apellido2 = usuarioModel.apellido2 ?? '';

    final nombreCompleto = '$nombre $apellido1 $apellido2';

    final List<Widget> actions = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConfig.cancelar,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          language.cancelar,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConfig.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          language.aceptar,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0x4D9489F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6F61EF),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Icon(
                  Icons.no_photography_outlined,
                  size: 48,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      nombreCompleto,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showConfirmDialog(
                        context,
                        title: language.seguro_borrar(
                          nombreCompleto,
                        ),
                        actions: actions,
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: ColorConfig.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
