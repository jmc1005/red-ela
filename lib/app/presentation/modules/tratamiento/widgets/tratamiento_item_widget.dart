import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/tratamiento/tratamiento_model.dart';
import '../../../global/dialogs/confirm_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/tratamiento_controller.dart';

class TratamientoItemWidget extends StatelessWidget {
  const TratamientoItemWidget(
      {super.key, required this.tratamientoModel, this.onTap});

  final TratamientoModel tratamientoModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final tratamientoController = Provider.of<TratamientoController>(context);

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
          final response =
              await tratamientoController.tratamientoRepo.deleteTratamiento(
            uuid: tratamientoModel.uuid,
          );
          response.when(
            (success) {
              Navigator.pop(context, true);
              navigateTo(Routes.tratamientoList, context);
            },
            (error) => tratamientoController.showResponseResult(
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
                      tratamientoModel.tratamiento,
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
                          tratamientoModel.tratamiento,
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
