import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/tratamiento/tratamiento_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/seccion_widget.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/tratamiento_controller.dart';

class TratamientoDetailView extends StatefulWidget {
  const TratamientoDetailView({super.key, required this.tratamientoModel});

  final TratamientoModel? tratamientoModel;

  @override
  State<TratamientoDetailView> createState() => _TratamientoDetailViewState();
}

class _TratamientoDetailViewState extends State<TratamientoDetailView>
    with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  var textTratamientoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final tratamiento = widget.tratamientoModel;

    if (tratamiento != null) {
      textTratamientoController.text = tratamiento.tratamiento;
    }

    return ChangeNotifierProvider<TratamientoController>(
      create: (_) => TratamientoController(
        tratamientoRepo: context.read(),
      ),
      child: Builder(builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            asset: 'images/redela_logo.png',
            backgroundColor: ColorConfig.primary,
            width: 90,
            leading: IconButton(
              onPressed: () {
                navigateTo(Routes.tratamientoList, context);
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
                              final tratamientoController =
                                  Provider.of<TratamientoController>(
                                context,
                                listen: false,
                              );

                              if (tratamientoController.state == null) {
                                tratamientoController.tratamiento =
                                    const TratamientoModel(
                                  uuid: '',
                                  tratamiento: '',
                                );
                              }

                              return Column(
                                children: [
                                  SeccionWidget(
                                    widget: Column(
                                      children: [
                                        TextFormWidget(
                                          label: language.tratamiento,
                                          controller: textTratamientoController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) =>
                                              textValidator(value, language),
                                          onChanged: (text) =>
                                              tratamientoController
                                                  .onChangeTratamiento(text),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                    title:
                                        language.datos_de(language.tratamiento),
                                  ),
                                  SubmitButtonWidget(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        tratamientoController.update(
                                            context, language);
                                        navigateTo(
                                            Routes.tratamientoList, context);
                                      } else {
                                        tratamientoController.showWarning(
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