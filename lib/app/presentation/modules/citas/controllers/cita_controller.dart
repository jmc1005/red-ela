import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/citas/cita_model.dart';
import '../../../../domain/models/citas/citas_datasource.dart';
import '../../../../utils/snackBar/snackbar_util.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../global/controllers/util_controller.dart';
import '../dialogs/cita_dialog.dart';

class CitaController extends StateNotifier<CitaModel?> {
  final List<Appointment> appointments = [];

  CitaController() : super(null);

  CitaModel get cita => _citaModel;

  set cita(CitaModel cita) {
    if (state != null) {
      _citaModel = cita;
    }

    onlyUpdate(_citaModel);
  }

  CitaModel _citaModel = const CitaModel(
    uidPaciente: '',
    uidGestorCasos: '',
    asunto: '',
    fechaInicio: '',
    horaInicio: '',
    fechaFin: '',
    horaFin: '',
    lugar: '',
  );

  CitaDataSource getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Meeting',
      color: Colors.red,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 5)),
      subject: 'Development Meeting   New York, U.S.A',
      color: const Color(0xfff527318),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 4)),
      subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
      color: const Color(0xfffb21f66),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 3)),
      subject: 'Support - Web Meeting   Dubai, UAE',
      color: const Color(0xfff3282b8),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(days: -2, hours: 1)),
      endTime: DateTime.now().add(const Duration(days: -2, hours: 2)),
      subject: 'Project Release Meeting   Istanbul, Turkey',
      color: const Color(0xfff2a7886),
    ));
    appointments.add(Appointment(
        startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
        endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
        subject: 'Release Meeting',
        color: Colors.lightBlueAccent,
        isAllDay: true));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 2, days: -4)),
      endTime: DateTime.now().add(const Duration(hours: 4, days: -4)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 11, days: -2)),
      endTime: DateTime.now().add(const Duration(hours: 12, days: -2)),
      subject: 'Customer Meeting   Tokyo, Japan',
      color: const Color(0xffffb8d62),
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6, days: 2)),
      endTime: DateTime.now().add(const Duration(hours: 7, days: 2)),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return CitaDataSource(appointments);
  }

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
      final fechaInicio =
          DateFormat('dd/MM/yyyy').format(appointment.startTime);
      final horaInicio = DateFormat('HH:mm').format(appointment.startTime);
      final fechaFin = DateFormat('dd/MM/yyyy').format(appointment.endTime);
      final horaFin = DateFormat('HH:mm').format(appointment.endTime);

      citaModel = CitaModel(
        uidPaciente: '',
        uidGestorCasos: '',
        asunto: appointment.subject,
        fechaInicio: fechaInicio,
        horaInicio: horaInicio,
        fechaFin: fechaFin,
        horaFin: horaFin,
        lugar: 'lugar',
      );

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
              crearCita(context);
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
      uidPaciente: '',
      uidGestorCasos: '',
      asunto: 'Nueva cita',
      fechaInicio: '',
      horaInicio: '',
      fechaFin: '',
      horaFin: '',
      lugar: 'lugar',
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

  void crearCita(context) {
    debugPrint(state!.toString());
    Navigator.pop(context);
  }

  void cancelarCita() {}

  Future<void> openDatePickerFechaInicio(context, dateInput) async {
    final utilController = UtilController(onChange: onChangeFechaInicio);
    utilController.openDatePicker(context, dateInput);
  }

  Future<void> openTimePickerHoraInicio(context, timeInput) async {
    final utilController = UtilController(onChange: onChangeHoraInicio);
    utilController.openTimePicker(context, timeInput);
  }

  Future<void> openDatePickerFechaFin(context, dateInput) async {
    final utilController = UtilController(onChange: onChangeFechaFin);
    utilController.openDatePicker(context, dateInput);
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
    onlyUpdate(state!.copyWith(fechaInicio: text));
  }

  void onChangeAsunto(text) {
    onlyUpdate(state!.copyWith(asunto: text));
  }

  void onChangeHoraInicio(text) {
    onlyUpdate(state!.copyWith(horaInicio: text));
  }

  void onChangeFechaFin(text) {
    onlyUpdate(state!.copyWith(fechaFin: text));
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
}
