import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../data/services/local/session_service.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/seccion_widget.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../cuidador/widgets/cuidador_data_widget.dart';
import '../../gestor_casos/widgets/gestor_casos_data_widget.dart';
import '../../paciente/widgets/paciente_patologia_widget.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/usuario_data_widget.dart';
import 'usuarios_view.dart';

class UsuarioDetailView extends StatefulWidget {
  const UsuarioDetailView({
    super.key,
    required this.usuarioModel,
    this.allowUpdate = false,
  });

  final UsuarioModel usuarioModel;
  final bool allowUpdate;

  @override
  State<UsuarioDetailView> createState() => _UsuarioDetailViewState();
}

class _UsuarioDetailViewState extends State<UsuarioDetailView> {
  final _formKey = GlobalKey<FormState>();
  late final BuildContext ctx;

  String? currentRol;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuario = widget.usuarioModel;

    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(
        sessionService: context.read(),
        usuarioRepo: context.read(),
        pacienteController: context.read(),
        cuidadorController: context.read(),
        gestorCasosController: context.read(),
        signController: context.read(),
      ),
      child: Builder(builder: (_) {
        final sessionService = Provider.of<SessionService>(
          context,
          listen: false,
        );

        return Scaffold(
          appBar: AppBarWidget(
            asset: 'images/redela_logo.png',
            backgroundColor: ColorConfig.primary,
            width: 90,
            leading: IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ctx = context;
                  _getCurrentRol(sessionService);

                  // if (currentRol != null &&
                  //     currentRol == UsuarioTipo.admin.value) {
                  //   _navegateToUsuarios(usuario);
                  // } else {
                  //   navigateTo(Routes.home, context);
                  // }
                  Navigator.pop(context);
                }
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
                              final usuarioController =
                                  Provider.of<UsuarioController>(context);

                              if (usuarioController.state == null) {
                                usuarioController.usuario = usuario;
                              }

                              final usuarioModel =
                                  usuarioController.state!.usuario;

                              final tipo = usuarioModel.rol.isNotEmpty
                                  ? usuarioModel.rol
                                  : UsuarioTipo.paciente.value;

                              return Column(
                                children: [
                                  SeccionWidget(
                                    title: language.datos_personales,
                                    widget: UsuarioDataWidget(
                                        usuarioController: usuarioController),
                                  ),
                                  if (tipo == UsuarioTipo.paciente.value)
                                    SeccionWidget(
                                      title: language.patologia,
                                      widget: PacientePatologiaWidget(
                                          usuarioController: usuarioController),
                                    ),
                                  if (tipo == UsuarioTipo.cuidador.value)
                                    SeccionWidget(
                                      title: language.patologia,
                                      widget: CuidadorDataWidget(
                                          usuarioController: usuarioController),
                                    ),
                                  if (tipo == UsuarioTipo.gestorCasos.value)
                                    SeccionWidget(
                                      title: language.patologia,
                                      widget: GestorCasosDataWidget(
                                          usuarioController: usuarioController),
                                    ),
                                  if (widget.allowUpdate)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SubmitButtonWidget(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              usuarioController.update(
                                                context,
                                                language,
                                              );
                                            } else {
                                              usuarioController.showWarning(
                                                  context, language);
                                            }
                                          },
                                          label: language.guardar,
                                        ),
                                      ],
                                    )
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

  void _navegateToUsuarios(usuario) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => UsuariosView(
          rol: usuario.rol,
        ),
      ),
    );
  }

  Future<void> _getCurrentRol(SessionService sessionService) async {
    currentRol = await sessionService.rol;
  }
}
