import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/rol/rol_model.dart';
import '../../../global/dialogs/confirm_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/rol_controller.dart';

class RolItemWidget extends StatelessWidget {
  const RolItemWidget({super.key, required this.rolModel, this.onTap});

  final RolModel rolModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final rolController = Provider.of<RolController>(context);

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
        onPressed: () async {
          final response = await rolController.rolRepo.deleteRol(
            uuid: rolModel.uuid,
          );
          response.when(
            (success) {
              Navigator.pop(context, true);
              navigateTo(Routes.rolList, context);
            },
            (error) => rolController.showResponseResult(
              context,
              error,
              false,
              language,
            ),
          );
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
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rolModel.descripcion,
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
                          rolModel.descripcion,
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
