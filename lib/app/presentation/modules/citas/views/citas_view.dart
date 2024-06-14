import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../user/controllers/usuario_controller.dart';
import '../controllers/cita_controller.dart';

class CitasView extends StatefulWidget {
  const CitasView({super.key});

  @override
  State<CitasView> createState() => _CitasViewState();
}

class _CitasViewState extends State<CitasView> {
  final _calendarController = CalendarController();
  final _keySfCalendar = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    final citaController = Provider.of<CitaController>(context);
    final UsuarioController usuarioController = context.read();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
      child: FutureBuilder(
        future: citaController.getCitas(usuarioController),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return calendar(citaController, height);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget loadMoreWidget(
    BuildContext context,
    LoadMoreCallback loadMoreAppointments,
  ) {
    return FutureBuilder<void>(
      initialData: 'loading',
      future: loadMoreAppointments(),
      builder: (_, snapShot) {
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget calendar(CitaController citaController, height) {
    return SfCalendar(
      key: _keySfCalendar,
      view: CalendarView.month,
      controller: _calendarController,
      allowedViews: const <CalendarView>[
        CalendarView.month,
        CalendarView.schedule
      ],
      dataSource: citaController.dataSource,
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
      onSelectionChanged: (calendarSelectionDetails) {
        debugPrint('$calendarSelectionDetails');
      },
      //loadMoreWidgetBuilder: loadMoreWidget,
      firstDayOfWeek: 1,
    );
  }
}
