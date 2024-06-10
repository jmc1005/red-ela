import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/hospital/hospital_model.dart';
import '../../../global/dialogs/confirm_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/hospital_controller.dart';

class HospitalItemWidget extends StatelessWidget {
  const HospitalItemWidget(
      {super.key, required this.hospitalModel, this.onTap});

  final HospitalModel hospitalModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final hospitalController = Provider.of<HospitalController>(context);

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
          final response = await hospitalController.hospitalRepo.deleteHospital(
            uuid: hospitalModel.uuid,
          );
          response.when(
            (success) {
              Navigator.pop(context, true);
              navigateTo(Routes.hospitalList, context);
            },
            (error) => hospitalController.showResponseResult(
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
                      hospitalModel.hospital,
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
                          hospitalModel.hospital,
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
