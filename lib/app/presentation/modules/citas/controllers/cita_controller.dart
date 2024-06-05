import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/citas/cita_model.dart';
import '../../../../domain/models/citas/citas_datasource.dart';
import '../../../global/controllers/state/state_notifier.dart';
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
      uid: '',
      asunto: '',
      fechaInicio: '',
      horaInicio: '',
      fechaFin: '',
      horaFin: '',
      lugar: '',
      uidPaciente: '');

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
      final Appointment cita = details.appointments![0];
      final fechaInicio = DateFormat('dd/MM/yyyy').format(cita.startTime);
      final horaInicio = DateFormat('HH:mm').format(cita.startTime);
      final fechaFin = DateFormat('dd/MM/yyyy').format(cita.endTime);
      final horaFin = DateFormat('HH:mm').format(cita.endTime);

      citaModel = CitaModel(
        uid: '',
        asunto: cita.subject,
        fechaInicio: fechaInicio,
        horaInicio: horaInicio,
        fechaFin: fechaFin,
        horaFin: horaFin,
        lugar: 'lugar',
        uidPaciente: '',
      );

      showCitaDialog(
        context,
        actions: actions,
        cita: citaModel,
        citaController: citaController,
      );
    }
  }

  void nuevaCita(context, usuarioModel, citaController) {
    final language = AppLocalizations.of(context)!;

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
          crearCita();
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
        uid: '',
        asunto: 'Nueva cita',
        fechaInicio: '',
        horaInicio: '',
        fechaFin: '',
        horaFin: '',
        lugar: 'lugar',
        uidPaciente: '');

    showCitaDialog(
      context,
      actions: actions,
      cita: citaModel,
      citaController: citaController,
      readOnly: false,
    );
  }

  void crearCita() {}
}
