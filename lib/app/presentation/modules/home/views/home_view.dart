import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../data/services/bloc/notificaciones_bloc.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/seccion_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../../citas/controllers/cita_controller.dart';
import '../../citas/views/citas_view.dart';
import '../../citas/widgets/recordatorio_widget.dart';
import '../../cuidador/widgets/cuidador_paciente_widget.dart';
import '../../gestor_casos/widgets/gestor_casos_pacientes_widget.dart';
import '../../invitacion/dialogs/invitar_usuario_dialog.dart';
import '../../paciente/widgets/paciente_cuidador_widget.dart';
import '../../paciente/widgets/paciente_gestor_casos_widget.dart';
import '../../user/controllers/usuario_controller.dart';
import '../../user/views/usuario_detail_view.dart';
import '../controller/home_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var openCuidadorAccordion = true;
  UsuarioModel? usuarioModel;
  bool showAddCita = false;
  bool showAddPaciente = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioRepo = Provider.of<UsuarioRepo>(context);
    final language = AppLocalizations.of(context)!;
    context.read<NotificacionesBloc>().requestPermission();

    final List<Widget> actions = [
      IconButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsuarioDetailView(
                usuarioModel: usuarioModel!,
                allowUpdate: true,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          usuarioRepo.signOut();
          navigateTo(Routes.signIn, context);
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    ];

    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(),
      child: FutureBuilder(
        future: _getUsuario(usuarioRepo),
        builder: (context, snapshot) {
          final homeController = Provider.of<HomeController>(context);

          final citaController = Provider.of<CitaController>(context);
          final usuarioController = Provider.of<UsuarioController>(context);

          if (snapshot.hasData) {
            final data = snapshot.data!;
            data.when(
              (success) {
                usuarioModel = success;
                usuarioController.usuario = success;
              },
              (error) => debugPrint(error),
            );
          }

          final isGestorCasos = usuarioModel != null &&
              usuarioModel!.rol == UsuarioTipo.gestorCasos.value;

          final isPaciente = usuarioModel != null &&
              usuarioModel!.rol == UsuarioTipo.paciente.value;

          final isCuidador = usuarioModel != null &&
              usuarioModel!.rol == UsuarioTipo.cuidador.value;

          showAddCita = homeController.currentIndex == 1 && isGestorCasos;
          showAddPaciente = homeController.currentIndex == 2 && isGestorCasos;

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBarWidget(
              asset: 'assets/images/redela_logo.png',
              actions: actions,
              width: 80,
              backgroundColor: ColorConfig.primary,
            ),
            bottomNavigationBar: BottomNavBar(
              onTap: (index) {
                homeController.onCurrentIndexChange(index);
              },
              controller: homeController,
            ),
            floatingActionButton: showAddCita
                ? FloatingActionButton(
                    onPressed: () {
                      citaController.nuevaCita(
                        context,
                        usuarioModel,
                        citaController,
                      );
                    },
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white, size: 25),
                  )
                : showAddPaciente
                    ? FloatingActionButton(
                        onPressed: () {
                          showInvitarUsuarioDialog(context,
                              rol: UsuarioTipo.gestorCasos.value);
                        },
                        mini: true,
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 25),
                      )
                    : null,
            body: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height / 1.3,
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height / 1.3,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (homeController.currentIndex == 0)
                          Expanded(
                            child: RecordatorioWidget(
                              citaController: citaController,
                            ),
                          ),
                        if (homeController.currentIndex == 1)
                          const Expanded(
                            child: CitasView(),
                          ),
                        if (homeController.currentIndex == 2 && isGestorCasos)
                          Expanded(
                            child: GestorCasosPacientesWidget(
                              usuarioController: usuarioController,
                            ),
                          ),
                        if (homeController.currentIndex == 2 && isPaciente)
                          Column(
                            children: [
                              SeccionWidget(
                                  widget: PacienteCuidadorWidget(
                                    usuarioController: usuarioController,
                                  ),
                                  title: language.cuidador),
                              SeccionWidget(
                                  widget: PacienteGestorCasosWidget(
                                    usuarioController: usuarioController,
                                  ),
                                  title: language.gestor_casos),
                            ],
                          ),
                        if (homeController.currentIndex == 2 && isCuidador)
                          SeccionWidget(
                              widget: CuidadorPacienteWidget(
                                usuarioController: usuarioController,
                              ),
                              title: language.paciente),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Result<UsuarioModel, dynamic>> _getUsuario(UsuarioRepo usuarioRepo) {
    return usuarioRepo.getUsuario();
  }
}
