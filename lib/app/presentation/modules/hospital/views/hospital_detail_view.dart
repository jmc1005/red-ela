import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/hospital/hospital_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/seccion_widget.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/hospital_controller.dart';

class HospitalDetailView extends StatefulWidget {
  const HospitalDetailView({super.key, required this.hospitalModel});

  final HospitalModel? hospitalModel;

  @override
  State<HospitalDetailView> createState() => _HospitalDetailViewState();
}

class _HospitalDetailViewState extends State<HospitalDetailView>
    with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  var textHospitalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final hospital = widget.hospitalModel;

    if (hospital != null) {
      textHospitalController.text = hospital.hospital;
    }

    return ChangeNotifierProvider<HospitalController>(
      create: (_) => HospitalController(
        hospitalRepo: context.read(),
      ),
      child: Builder(builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            asset: 'images/redela_logo.png',
            backgroundColor: ColorConfig.primary,
            width: 90,
            leading: IconButton(
              onPressed: () {
                navigateTo(Routes.hospitalList, context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Flexible(
                      child: Wrap(
                        children: [
                          Form(
                            key: _formKey,
                            child: Builder(builder: (context) {
                              final hospitalController =
                                  Provider.of<HospitalController>(
                                context,
                                listen: false,
                              );

                              if (hospitalController.state == null) {
                                hospitalController.hospital =
                                    const HospitalModel(
                                  uuid: '',
                                  hospital: '',
                                );
                              }

                              return Column(
                                children: [
                                  SeccionWidget(
                                    widget: Column(
                                      children: [
                                        TextFormWidget(
                                          label: language.hospital,
                                          controller: textHospitalController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) =>
                                              textValidator(value, language),
                                          onChanged: (text) =>
                                              hospitalController
                                                  .onChangeHospital(text),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                    title: language.datos_de(language.hospital),
                                  ),
                                  const SizedBox(height: 8),
                                  SubmitButtonWidget(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        hospitalController.update(
                                            context, language);
                                        navigateTo(
                                            Routes.hospitalList, context);
                                      } else {
                                        hospitalController.showWarning(
                                            context, language);
                                      }
                                    },
                                    label: language.guardar,
                                  ),
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
