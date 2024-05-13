import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/widgets/accordion_widget.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../../cuidador/widgets/cuidador_data_widget.dart';
import '../../paciente/widgets/paciente_data_widget.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/usuario_data_widget.dart';

class UsuarioDetailView extends StatefulWidget {
  const UsuarioDetailView({
    super.key,
    required this.usuarioModel,
  });

  final UsuarioModel usuarioModel;

  @override
  State<UsuarioDetailView> createState() => _UsuarioDetailViewState();
}

class _UsuarioDetailViewState extends State<UsuarioDetailView> {
  final _formKey = GlobalKey<FormState>();
  var openDatosPersonales = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    var usuario = widget.usuarioModel;

    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(
        usuarioRepo: context.read(),
        context: context,
        pacienteController: context.read(),
      ),
      child: Scaffold(
        appBar: AppBarWidget(
          asset: 'images/redela_logo.png',
          backgroundColor: ColorConfig.primary,
          leading: IconButton(
            onPressed: () {
              navigateTo(Routes.userList, context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConfig.secondary,
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
                  // const CircleAvatar(
                  //   backgroundColor: ColorConfig.secondary,
                  //   radius: 50,
                  //   child: Text(
                  //     'Avatar',
                  //     style: TextStyle(
                  //       fontSize: 25,
                  //       color: Colors.white,
                  //     ),
                  //   ), //Text
                  // ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Wrap(
                      children: [
                        Form(
                          key: _formKey,
                          child: Builder(builder: (context) {
                            final UsuarioController usuarioController =
                                context.read();

                            if (usuarioController.state == null) {
                              usuarioController.usuario = usuario;
                            }

                            final usuarioModel =
                                usuarioController.state!.usuario;

                            final tipo = usuarioModel.rol != null &&
                                    usuarioModel.rol!.isNotEmpty
                                ? usuarioModel.rol
                                : UsuarioTipo.paciente.value;
                            return Column(
                              children: [
                                AccordionWidget(children: [
                                  AccordionSection(
                                    header: Text(language.datos_personales),
                                    contentVerticalPadding: 20,
                                    content: UsuarioDataWidget(
                                      usuarioController: usuarioController,
                                    ),
                                    isOpen: openDatosPersonales,
                                  ),
                                  AccordionSection(
                                    header: Text(language.tipo_usuario),
                                    contentVerticalPadding: 20,
                                    content: Column(
                                      children: [
                                        if (tipo == UsuarioTipo.paciente.value)
                                          PacienteDataWidget(
                                            usuarioController:
                                                usuarioController,
                                          ),
                                        if (tipo == UsuarioTipo.cuidador.value)
                                          CuidadorDataWidget(
                                            usuarioController:
                                                usuarioController,
                                          ),
                                      ],
                                    ),
                                    isOpen: !openDatosPersonales,
                                  ),
                                ]),
                                SizedBox(
                                  height: 54,
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        usuarioController.update(
                                            context, language);
                                      }
                                    },
                                    child: Text(
                                      language.guardar,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }
}
