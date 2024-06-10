import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../domain/models/cita/citas_datasource.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../user/controllers/usuario_controller.dart';
import '../controllers/cita_controller.dart';

class CitasView extends StatefulWidget {
  const CitasView({super.key});

  @override
  State<CitasView> createState() => _CitasViewState();
}

class _CitasViewState extends State<CitasView> {
  final _calendarController = CalendarController();

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
        future: citaController.getCitas(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            data.when(
              (success) async {
                var citas = success;
                final usuarioResponse =
                    await usuarioController.usuarioRepo.getUsuario();

                usuarioResponse.when(
                  (success) async {
                    var uid = success.uid;

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

                          citas = citas
                              .where(
                                (c) => c.uidPaciente == uid,
                              )
                              .toList();

                          citaController.citas.addAll(citas);

                          for (final c in citas) {
                            citaController.addCitaToAppointments(c);
                          }
                        },
                        (error) => debugPrint(error),
                      );
                    } else {
                      citas = citas
                          .where((c) =>
                              c.uidPaciente == uid || c.uidGestorCasos == uid)
                          .toList();
                      for (final c in citas) {
                        citaController.addCitaToAppointments(c);
                      }
                    }
                  },
                  (error) => debugPrint(error),
                );
              },
              (error) => debugPrint(error),
            );

            return SfCalendar(
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
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
