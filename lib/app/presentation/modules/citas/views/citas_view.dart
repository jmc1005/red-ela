import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/cita_controller.dart';

class CitasView extends StatefulWidget {
  const CitasView({super.key});

  @override
  State<CitasView> createState() => _CitasViewState();
}

class _CitasViewState extends State<CitasView> {
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    final citaController = Provider.of<CitaController>(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
      child: SfCalendar(
        view: CalendarView.month,
        controller: _controller,
        allowedViews: const <CalendarView>[
          CalendarView.month,
          CalendarView.schedule
        ],
        dataSource: citaController.getDataSource(),
        cellEndPadding: 5,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: height,
        ),
        appointmentTimeTextFormat: 'HH:mm',
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeFormat: 'HH:mm',
          timeIntervalHeight: -1,
        ),
        onTap: (details) => citaController.calendarTap(
          details,
          context,
          citaController,
        ),
      ),
    );
  }
}
