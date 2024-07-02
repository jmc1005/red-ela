import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/services/local/preferencias_usuario.dart';
import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/models/usuario_tipo/usuario_tipo_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/enums/inicio_enum.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../global/controllers/util_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../../cuidador/controllers/cuidador_controller.dart';
import '../../gestor_casos/controllers/gestor_casos_controller.dart';
import '../../paciente/controllers/paciente_controller.dart';
import '../../sign/controllers/sign_controller.dart';

class UsuarioController extends StateNotifier<UsuarioTipoModel?> {
  UsuarioController({
    required this.context,
    required this.usuarioRepo,
    required this.pacienteController,
    required this.cuidadorController,
    required this.gestorCasosController,
    required this.signController,
  }) : super(null);

  final BuildContext context;
  final UsuarioRepo usuarioRepo;
  final PacienteController pacienteController;
  final CuidadorController cuidadorController;
  final GestorCasosController gestorCasosController;
  final SignController signController;

  set usuario(UsuarioModel usuarioModel) {
    UsuarioTipoModel usuarioTipoModel;
    if (state == null) {
      usuarioTipoModel = UsuarioTipoModel(usuario: usuarioModel);
    } else {
      usuarioTipoModel = state!.copyWith(usuario: usuarioModel);
    }

    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set paciente(PacienteModel pacienteModel) {
    final usuarioTipoModel = state!.copyWith(paciente: pacienteModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set cuidador(CuidadorModel cuidadorModel) {
    final usuarioTipoModel = state!.copyWith(cuidador: cuidadorModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set gestorCasos(GestorCasosModel gestorCasosModel) {
    final usuarioTipoModel = state!.copyWith(gestorCasos: gestorCasosModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  void onChangeValueNombre(String text) {
    usuario = state!.usuario.copyWith(nombre: text);
  }

  void onChangeValueApellido1(String text) {
    usuario = state!.usuario.copyWith(apellido1: text);
  }

  void onChangeValueApellido2(String text) {
    usuario = state!.usuario.copyWith(apellido2: text);
  }

  void onChangeValueTelefono(String text) {
    usuario = state!.usuario.copyWith(telefono: text);
  }

  void onChangeValueEmail(String text) {
    usuario = state!.usuario.copyWith(email: text);
  }

  void onPasswordChanged(String text) {
    usuario = state!.usuario.copyWith(password: text);
  }

  void onChangeValueFechaNacimiento(String text) {
    usuario = state!.usuario.copyWith(fechaNacimiento: text);
  }

  void onChangeTratamiento(String text) {
    paciente = state!.paciente!.copyWith(tratamiento: text);
  }

  void onChangeValueInicio(String text) {
    paciente = state!.paciente!.copyWith(inicio: text);
  }

  void onChangeValueFechaDiagnostico(String text) {
    paciente = state!.paciente!.copyWith(fechaDiagnostico: text);
  }

  void onChangeCuidadorPaciente(String text) {
    paciente = state!.paciente!.copyWith(gestorCasos: text);
  }

  void onChangeRelacion(String text) {
    cuidador = state!.cuidador!.copyWith(relacion: text);
  }

  void onChangeHospital(String text) {
    gestorCasos = state!.gestorCasos!.copyWith(hospital: text);
  }

  void onVisibilityPasswordChanged(bool visible) {
    signController.onVisibilityPasswordChanged(visible);
  }

  void onVisibilityConfirmPasswordChanged(bool visible) {
    signController.onVisibilityConfirmPasswordChanged(visible);
  }

  Future<void> openDatePicker(
    BuildContext context,
    TextEditingController dateInput,
  ) async {
    final utilController =
        UtilController(onChange: onChangeValueFechaNacimiento);

    utilController.openDatePicker(context, dateInput);
  }

  Future<void> openDatePickerFechaDiagnostico(
    BuildContext context,
    TextEditingController dateInput,
  ) async {
    final utilController =
        UtilController(onChange: onChangeValueFechaDiagnostico);

    utilController.openDatePicker(context, dateInput);
  }

  Future<void> update(context, language) async {
    final result = await usuarioRepo.updateUsuario(
      uid: state!.usuario.uid,
      nombre: state!.usuario.nombre!,
      apellido1: state!.usuario.apellido1!,
      apellido2: state!.usuario.apellido2!,
      email: state!.usuario.email!,
      fechaNacimiento: state!.usuario.fechaNacimiento!,
      telefono: state!.usuario.telefono!,
      password: state!.usuario.password,
      rol: state!.usuario.rol,
    );

    await updateUsuarioPorTipo(state!.usuario.rol);

    late String code;
    late bool isSuccess = true;

    result.when((success) {
      code = success;

      if (state!.usuario.rol == UsuarioTipo.admin.value) {
        navigateTo(Routes.admin, context);
      } else {
        navigateTo(Routes.home, context);
      }
    }, (error) {
      code = error;
      isSuccess = false;
    });

    final response = FirebaseResponse(
      context: context,
      language: language,
      code: code,
    );

    if (isSuccess) {
      response.showSuccess();
    } else {
      response.showError();
    }
  }

  void showWarning(context, language) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: FirebaseCode.reviewFormData,
    );

    response.showWarning();
  }

  Future<void> updateUsuarioPorTipo(rol) async {
    final prefs = PreferenciasService();
    final solicitado = prefs.solicitado;

    if (rol == UsuarioTipo.paciente.value) {
      String? gestorCasos;

      if (solicitado != null && solicitado.isNotEmpty) {
        gestorCasos = solicitado;
        onChangeCuidadorPaciente(gestorCasos);
        await gestorCasosController.gestorCasosRepo
            .relacionaGestorCasosPaciente(uidGestorCasos: solicitado);
      }

      if (state!.usuario.uid == '') {
        await pacienteController.pacienteRepo.addPaciente(
          tratamiento: state!.paciente?.tratamiento ?? '',
          fechaDiagnostico: state!.paciente?.fechaDiagnostico ?? '',
          inicio: state!.paciente?.inicio ?? '',
          gestorCasos: gestorCasos,
        );
      } else {
        await pacienteController.pacienteRepo.updatePaciente(
          tratamiento: state!.paciente?.tratamiento ?? '',
          fechaDiagnostico: state!.paciente?.fechaDiagnostico ?? '',
          inicio: state!.paciente?.inicio ?? '',
          gestorCasos: state!.paciente?.gestorCasos,
        );
      }
    } else if (rol == UsuarioTipo.cuidador.value) {
      String? paciente;

      if (solicitado != null && solicitado.isNotEmpty) {
        paciente = solicitado;

        await pacienteController.pacienteRepo.relacionaPacienteCuidador(
          uidPaciente: paciente,
        );
      }

      if (state!.usuario.uid == '') {
        await cuidadorController.cuidadorRepo.addCuidador(
          relacion: state!.cuidador!.relacion,
          paciente: paciente,
        );
      } else {
        await cuidadorController.cuidadorRepo.updateCuidador(
          relacion: state!.cuidador!.relacion,
          paciente: paciente,
        );
      }
    } else if (rol == UsuarioTipo.gestorCasos.value) {
      if (state!.usuario.uid == '') {
        await gestorCasosController.gestorCasosRepo.addGestorCasos(
          hospital: state!.gestorCasos!.hospital!,
        );
      } else {
        await gestorCasosController.gestorCasosRepo.updateGestorCasos(
          hospital: state!.gestorCasos!.hospital!,
        );
      }
    }

    prefs.solicitado = '';
  }

  Future<void> borrarUsuarioPorTipo(rol, uid) async {
    await usuarioRepo.deleteUsuarioByUid(uid: uid);

    if (rol == UsuarioTipo.paciente.value) {
      await pacienteController.pacienteRepo.deletePacienteByUid(
        uid: uid,
      );
    } else if (rol == UsuarioTipo.cuidador.value) {
      await cuidadorController.cuidadorRepo.deleteCuidadorByUid(
        uid: uid,
      );
    } else if (rol == UsuarioTipo.gestorCasos.value) {
      await gestorCasosController.gestorCasosRepo.deleteGestorCasosByUid(
        uid: uid,
      );
    }
  }

  List<DropdownMenuItem<String>> get dropdownInicioItems {
    final language = AppLocalizations.of(context)!;

    return InicioEnum.values.map<DropdownMenuItem<String>>(
      (InicioEnum inicio) {
        final label = getInicioString(inicio, language);

        return DropdownMenuItem<String>(
          value: inicio.value,
          alignment: Alignment.center,
          child: Text(label),
        );
      },
    ).toList();
  }

  String getInicioString(InicioEnum enumInicio, AppLocalizations language) {
    switch (enumInicio) {
      case InicioEnum.bulbar:
        return language.bulbar;
      case InicioEnum.espinal:
        return language.espinal;
    }
  }
}
