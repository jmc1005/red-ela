import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/rol/rol_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/accordion_widget.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/rol_controller.dart';

class RolDetailView extends StatefulWidget {
  const RolDetailView({super.key, required this.rolModel});

  final RolModel? rolModel;

  @override
  State<RolDetailView> createState() => _RolDetailViewState();
}

class _RolDetailViewState extends State<RolDetailView> with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  var textRolController = TextEditingController();
  var textDescripcionController = TextEditingController();
  var headerStyle = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final rol = widget.rolModel;

    if (rol != null) {
      textRolController.text = rol.rol;
      textDescripcionController.text = rol.descripcion;
    }

    return ChangeNotifierProvider<RolController>(
      create: (_) => RolController(
        rolRepo: context.read(),
      ),
      child: Builder(builder: (_) {
        return Scaffold(
          appBar: AppBarWidget(
            asset: 'images/redela_logo.png',
            backgroundColor: ColorConfig.primary,
            width: 90,
            leading: IconButton(
              onPressed: () {
                navigateTo(Routes.rolList, context);
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
                              final rolController = Provider.of<RolController>(
                                context,
                                listen: false,
                              );

                              if (rolController.state == null) {
                                rolController.rol = const RolModel(
                                  uuid: '',
                                  rol: '',
                                  descripcion: '',
                                );
                              }

                              return Column(
                                children: [
                                  AccordionWidget(children: [
                                    AccordionSection(
                                      header: Text(
                                        language.datos_de(language.rol),
                                        style: headerStyle,
                                      ),
                                      headerBackgroundColor:
                                          ColorConfig.primary,
                                      headerBackgroundColorOpened:
                                          ColorConfig.primary,
                                      contentVerticalPadding: 20,
                                      contentBackgroundColor:
                                          ColorConfig.primaryBackground,
                                      content: Column(
                                        children: [
                                          TextFormWidget(
                                            label: language.rol,
                                            controller: textRolController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) =>
                                                textValidator(value, language),
                                            onChanged: (text) =>
                                                rolController.onChangeRol(text),
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormWidget(
                                            label: language.descripcion,
                                            controller:
                                                textDescripcionController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) =>
                                                textValidator(value, language),
                                            onChanged: (text) => rolController
                                                .onChangeDescripcion(text),
                                          ),
                                        ],
                                      ),
                                      isOpen: true,
                                    ),
                                  ]),
                                  SubmitButtonWidget(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        rolController.update(context, language);
                                        navigateTo(Routes.rolList, context);
                                      } else {
                                        rolController.showWarning(
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