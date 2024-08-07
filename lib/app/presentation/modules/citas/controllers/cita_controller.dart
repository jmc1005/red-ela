import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/color_config.dart';
import '../../../../data/services/bloc/notificaciones_bloc.dart';
import '../../../../domain/models/cita/cita_model.dart';
import '../../../../domain/models/cita/citas_datasource.dart';
import '../../../../domain/repository/cita_repo.dart';
import '../../../../domain/repository/paciente_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/snackBar/snackbar_util.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../global/controllers/util_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../../user/controllers/usuario_controller.dart';
import '../dialogs/cita_dialog.dart';

class CitaController extends StateNotifier<CitaModel?> {
  final List<Appointment> appointments = [];
  List<CitaModel> citas = [];

  CitaController({
    required this.citaRepo,
  }) : super(null);

  final CitaRepo citaRepo;

  String get uuidCitaSel => _uuidCitaSel;

  String _uuidCitaSel = '';

  CitaModel get cita => _citaModel;

  set cita(CitaModel cita) {
    if (state != null) {
      _citaModel = cita;
    }

    onlyUpdate(_citaModel);
  }

  CitaModel _citaModel = const CitaModel(
    uuid: '',
    uidPaciente: '',
    uidGestorCasos: '',
    asunto: '',
    fecha: '',
    horaInicio: '',
    horaFin: '',
    lugar: '',
  );

  final _dataSource = CitaDataSource([]);

  CitaDataSource get dataSource => _dataSource;

  String get rol => _rol;
  set rol(rol) => _rol = rol;
  String _rol = UsuarioTipo.paciente.value;

  void calendarTap(
    CalendarTapDetails details,
    BuildContext context,
    CitaController citaController,
  ) {
    final CitaModel citaModel;
    final language = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointment = details.appointments![0];

      final isReadOnly = (appointment.startTime.isBefore(DateTime.now()) &&
              rol == UsuarioTipo.gestorCasos.value) ||
          rol != UsuarioTipo.gestorCasos.value;

      final actions = getActions(context, language, formKey, isReadOnly);

      _uuidCitaSel = appointment.id!.toString();

      citaModel = citas
          .where(
            (c) => c.uuid == appointment.id!.toString(),
          )
          .first;

      cita = citaModel;

      showCitaDialog(
        context,
        actions: actions,
        cita: citaModel,
        citaController: citaController,
        formKey: formKey,
        readOnly: isReadOnly,
      );
    }
  }

  List<Widget> getActions(BuildContext context, AppLocalizations language,
      GlobalKey<FormState> formKey, bool isReadOnly) {
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
      if (!isReadOnly)
        OutlinedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final partsInicio = state!.horaInicio.split(':');
              final hourInicio = int.parse(partsInicio[0]);
              final minuteInicio = int.parse(partsInicio[1]);

              final partsFin = state!.horaFin.split(':');
              final hourFin = int.parse(partsFin[0]);
              final minuteFin = int.parse(partsFin[1]);

              final timeInicio =
                  TimeOfDay(hour: hourInicio, minute: minuteInicio);
              final timeFin = TimeOfDay(hour: hourFin, minute: minuteFin);

              final isFinPosterior = timeFin.hour > timeInicio.hour ||
                  (timeFin.hour == timeInicio.hour &&
                      timeFin.minute > timeInicio.minute);

              if (!isFinPosterior) {
                final snackbarUtil = SnackBarUtils(
                  context: context,
                  message: language.error_hora,
                );
                snackbarUtil.showWarning();
              } else {
                crearCita(context, language);
              }
            }
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
    return actions;
  }

  void nuevaCita(context, usuarioModel, citaController) {
    final language = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    final actions = getActions(context, language, formKey, false);

    const citaModel = CitaModel(
      uuid: '',
      uidPaciente: '',
      uidGestorCasos: '',
      asunto: '',
      fecha: '',
      horaInicio: '',
      horaFin: '',
      lugar: '',
    );

    cita = citaModel;

    showCitaDialog(
      context,
      actions: actions,
      cita: citaModel,
      citaController: citaController,
      formKey: formKey,
      readOnly: false,
    );
  }

  Future<void> crearCita(context, language) async {
    final Result<dynamic, dynamic> response;
    if (cita.uuid.isNotEmpty) {
      response = await citaRepo.updateCita(
          uuid: state!.uuid,
          uidPaciente: state!.uidPaciente,
          asunto: state!.asunto,
          fecha: state!.fecha,
          horaInicio: state!.horaInicio,
          horaFin: state!.horaFin,
          lugar: state!.lugar,
          notas: state!.notas ?? '');
    } else {
      response = await citaRepo.addCita(
          uidPaciente: state!.uidPaciente,
          asunto: state!.asunto,
          fecha: state!.fecha,
          horaInicio: state!.horaInicio,
          horaFin: state!.horaFin,
          lugar: state!.lugar,
          notas: state!.notas ?? '');
    }

    response.when(
      (success) async {
        showSuccess(context, language, success);
        Navigator.pop(context);
        await enviarNotificacionPaciente(context, false);
      },
      (error) => showError(context, language, error),
    );

    Navigator.pop(context);
    navigateTo(Routes.home, context);
  }

  Future<void> cancelarCita(context) async {
    final appointment = appointments
        .where(
          (a) => a.id.toString() == uuidCitaSel,
        )
        .first;

    final cita = citas
        .where(
          (c) => c.uuid == uuidCitaSel,
        )
        .first;

    dataSource.appointments!.remove(appointment);
    dataSource.notifyListeners(
      CalendarDataSourceAction.remove,
      <Appointment>[appointment],
    );

    citas.remove(cita);

    citaRepo.deleteCita(uuid: uuidCitaSel);
    await enviarNotificacionPaciente(context, true);
    await enviarNotificacionGestorCasos(context);
  }

  Future<void> openDatePickerFechaInicio(context, dateInput) async {
    final utilController = UtilController(onChange: onChangeFechaInicio);
    utilController.openDatePicker(context, dateInput);
  }

  Future<void> openTimePickerHoraInicio(context, timeInput) async {
    final utilController = UtilController(onChange: onChangeHoraInicio);
    utilController.openTimePicker(context, timeInput);
  }

  Future<void> openTimePickerHoraFin(context, timeInput) async {
    final utilController = UtilController(onChange: onChangeHoraFin);
    utilController.openTimePicker(context, timeInput);
  }

  void onChangeUidPaciente(text) {
    onlyUpdate(state!.copyWith(uidPaciente: text));
  }

  void onChangeUidGestorCasos(text) {
    onlyUpdate(state!.copyWith(uidGestorCasos: text));
  }

  void onChangeFechaInicio(text) {
    onlyUpdate(state!.copyWith(fecha: text));
  }

  void onChangeAsunto(text) {
    onlyUpdate(state!.copyWith(asunto: text));
  }

  void onChangeHoraInicio(text) {
    onlyUpdate(state!.copyWith(horaInicio: text));
  }

  void onChangeHoraFin(text) {
    onlyUpdate(state!.copyWith(horaFin: text));
  }

  void onChangeLugar(text) {
    onlyUpdate(state!.copyWith(lugar: text));
  }

  void onChangeNotas(text) {
    onlyUpdate(state!.copyWith(notas: text));
  }

  Future<List<Appointment>> getCitas(
      UsuarioController usuarioController) async {
    await getCitasFromRepo(usuarioController);

    return Future.value(appointments);
  }

  Future<void> getCitasFromRepo(UsuarioController usuarioController) async {
    final responseCitas = await citaRepo.getCitas();

    responseCitas.when(
      (success) async {
        clear();

        var citasSuccess = success;
        final usuarioResponse =
            await usuarioController.usuarioRepo.getUsuario();

        usuarioResponse.when(
          (success) async {
            var uid = success.uid;
            rol = success.rol;

            if (success.rol == UsuarioTipo.cuidador.value) {
              final cuidadorResponse = await usuarioController
                  .cuidadorController.cuidadorRepo
                  .getCuidador();
              cuidadorResponse.when(
                (success) {
                  if (success.pacientes != null &&
                      success.pacientes!.isNotEmpty) {
                    uid = success.pacientes![0];
                  }

                  citasSuccess = citasSuccess
                      .where(
                        (c) => c.uidPaciente == uid,
                      )
                      .toList();

                  citas.addAll(citasSuccess);

                  if (citas.isNotEmpty) {
                    for (final c in citas) {
                      addCitaToAppointments(c);
                    }

                    notifyListenersAppointments();
                  }
                },
                (error) => debugPrint(error),
              );
            } else {
              citasSuccess = citasSuccess
                  .where((c) => c.uidPaciente == uid || c.uidGestorCasos == uid)
                  .toList();

              citas.addAll(citasSuccess);
              if (citas.isNotEmpty) {
                for (final c in citas) {
                  addCitaToAppointments(c);
                }

                notifyListenersAppointments();
              }
            }
          },
          (error) => debugPrint(error),
        );
      },
      (error) => debugPrint(error),
    );
  }

  void addCitaToAppointments(CitaModel cita) {
    if (cita.horaInicio.isNotEmpty && cita.horaFin.isNotEmpty) {
      final appointment = createAppointment(cita);

      if (!citas.any((c) => c.uuid == cita.uuid)) {
        citas.add(cita);
      }

      if (!appointments.any((a) => a.id != null && a.id! == cita.uuid)) {
        appointments.add(appointment);
      }
    }
  }

  void updateCitaToAppointments(CitaModel cita) {
    citas = citas.where((c) => c.uuid != cita.uuid).toList();
    citas.add(cita);

    final index = appointments.indexWhere((a) => a.id != cita.uuid);
    if (index != -1) {
      final updateAppointment = createAppointment(cita);

      dataSource.appointments!.remove(appointments[index]);
      dataSource.appointments!.add(updateAppointment);

      notifyListeners();
    }
  }

  void notifyListenersAppointments() {
    if (dataSource.appointments != null) {
      dataSource.appointments!.clear();
      dataSource.appointments!.addAll(appointments);
      dataSource.notifyListeners(
        CalendarDataSourceAction.add,
        appointments,
      );
    }
  }

  Appointment createAppointment(CitaModel cita) {
    final inicioString = '${cita.fecha} ${cita.horaInicio}';
    final finString = '${cita.fecha} ${cita.horaFin}';

    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final dtInicio = formatter.parse(inicioString);
    final dtFin = formatter.parse(finString);

    final random = Random();
    final colors = [
      Colors.red,
      Colors.purple,
      Colors.green,
      Colors.blue,
      Colors.deepOrange,
      Colors.indigoAccent,
      Colors.teal
    ];

    final appointment = Appointment(
      id: cita.uuid,
      startTime: dtInicio,
      endTime: dtFin,
      subject: cita.asunto,
      location: cita.lugar,
      notes: cita.notas != null ? cita.notas! : '',
      color: colors[random.nextInt(colors.length)],
    );
    return appointment;
  }

  Future<void> enviarNotificacionPaciente(
    BuildContext context,
    bool cancelar,
  ) async {
    final blocNotificacion = context.read<NotificacionesBloc>();
    final usuarioRepo = context.read<UsuarioRepo>();
    final pacienteRepo = context.read<PacienteRepo>();
    final language = AppLocalizations.of(context)!;

    final titulo = cancelar
        ? '${cita.asunto} ${language.cancelada}'
        : '${cita.asunto} ${language.creada}';
    final cuerpo = '${cita.horaInicio} ${cita.horaFin}';

    final response = await usuarioRepo.getUsuarioByUid(uid: state!.uidPaciente);
    response.when(
      (success) async {
        blocNotificacion.sendPushMessage(
          titulo,
          cuerpo,
          success.token,
        );

        final responsePaciente = await pacienteRepo.getPacienteByUid(
          success.uid,
        );

        responsePaciente.when(
          (sucPaciente) async {
            if (sucPaciente.cuidador != null) {
              final responseCuidador = await usuarioRepo.getUsuarioByUid(
                uid: sucPaciente.cuidador!,
              );

              responseCuidador.when(
                (sucCuidador) => blocNotificacion.sendPushMessage(
                  titulo,
                  cuerpo,
                  sucCuidador.token,
                ),
                (errorCuidador) => debugPrint(errorCuidador),
              );
            }
          },
          (errorPac) => debugPrint(errorPac),
        );
      },
      (error) => debugPrint(error),
    );
  }

  Future<void> enviarNotificacionGestorCasos(BuildContext context) async {
    final blocNotificacion = context.read<NotificacionesBloc>();
    final usuarioRepo = context.read<UsuarioRepo>();
    final language = AppLocalizations.of(context)!;

    final titulo = '${cita.asunto} ${language.cancelada}';
    final cuerpo = '${cita.horaInicio} ${cita.horaFin}';

    final response =
        await usuarioRepo.getUsuarioByUid(uid: state!.uidGestorCasos);
    response.when(
      (success) => blocNotificacion.sendPushMessage(
        titulo,
        cuerpo,
        success.token,
      ),
      (error) => debugPrint(error),
    );
  }

  void clear() {
    if (appointments.isNotEmpty) {
      appointments.clear();
    }
    if (citas.isNotEmpty) {
      citas.clear();
    }
    if (dataSource.appointments != null &&
        dataSource.appointments!.isNotEmpty) {
      dataSource.appointments!.clear();
    }
  }

  void showSuccess(context, language, whenSuccess) {
    final fbResponse = FirebaseResponse(
      context: context,
      language: language,
      code: whenSuccess,
    );

    fbResponse.showSuccess();
    if (cita.uuid.isEmpty) {
      addCitaToAppointments(cita);
    } else {
      updateCitaToAppointments(cita);
    }
  }

  void showError(context, language, error) {
    debugPrint(error);

    final fbResponse = FirebaseResponse(
      context: context,
      language: language,
      code: error,
    );

    fbResponse.showError();
  }
}
