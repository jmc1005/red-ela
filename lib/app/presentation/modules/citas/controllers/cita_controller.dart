import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/cita/cita_model.dart';
import '../../../../domain/models/cita/citas_datasource.dart';
import '../../../../domain/repository/cita_repo.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/snackBar/snackbar_util.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../global/controllers/util_controller.dart';
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

  void calendarTap(
    CalendarTapDetails details,
    BuildContext context,
    CitaController citaController,
  ) {
    final CitaModel citaModel;
    final language = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

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
    ];

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointment = details.appointments![0];

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
      );
    }
  }

  void nuevaCita(context, usuarioModel, citaController) {
    final language = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

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
    final response = await citaRepo.addCita(
        uidPaciente: state!.uidPaciente,
        asunto: state!.asunto,
        fecha: state!.fecha,
        horaInicio: state!.horaInicio,
        horaFin: state!.horaFin,
        lugar: state!.lugar,
        notas: state!.notas ?? '');

    var isSuccess = false;
    var code = '';

    response.when(
      (whenSuccess) {
        isSuccess = true;
        code = whenSuccess;
      },
      (whenError) {
        isSuccess = false;
        code = whenError;
        debugPrint(whenError);
      },
    );

    final fbResponse = FirebaseResponse(
      context: context,
      language: language,
      code: code,
    );

    if (isSuccess) {
      fbResponse.showSuccess();
      addCitaToAppointments(cita);
      enviarNotificacion();
    } else {
      fbResponse.showError();
    }

    Navigator.pop(context);
  }

  void cancelarCita() {
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

  Future<Result<List<CitaModel>, dynamic>> getCitas() async {
    return citaRepo.getCitas();
  }

  void addCitaToAppointments(CitaModel cita) {
    final inicioString = '${cita.fecha} ${cita.horaInicio}';
    final finString = '${cita.fecha} ${cita.horaFin}';

    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final dtInicio = formatter.parse(inicioString);
    final dtFin = formatter.parse(finString);

    final random = Random();
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    final color = Color.fromRGBO(r, g, b, 1);

    final appointment = Appointment(
      id: cita.uuid,
      startTime: dtInicio,
      endTime: dtFin,
      subject: cita.asunto,
      location: cita.lugar,
      notes: cita.notas != null ? cita.notas! : '',
      color: color,
    );

    appointments.add(appointment);
    citas.add(cita);

    dataSource.appointments!.addAll(appointments);
    dataSource.notifyListeners(
      CalendarDataSourceAction.add,
      <Appointment>[appointment],
    );
  }

  void enviarNotificacion() {}
}
