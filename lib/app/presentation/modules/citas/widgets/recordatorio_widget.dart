import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/cita/cita_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../controllers/cita_controller.dart';

class RecordatorioWidget extends StatelessWidget {
  const RecordatorioWidget({super.key, required this.citaController});

  final CitaController citaController;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: getCitas(citaController),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final citas = snapshot.data!;
          if (citas.isNotEmpty) {
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (_, index) {
                final cita = citas[index];

                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x25090F13),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cita.asunto,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 24,
                            thickness: 2,
                            color: Color(0xFFF1F4F8),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${cita.horaInicio} - ${cita.horaFin}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cita.lugar,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x25090F13),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        child: Text(
                          language.sin_citas,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<CitaModel>> getCitas(CitaController citaController) async {
    var citas = <CitaModel>[];
    final response = await citaController.citaRepo.getCitas();

    response.when(
      (success) {
        final String hoy = DateFormat(
          AppConstants.formatDate,
        ).format(
          DateTime.now(),
        );

        citas = success.where((s) => s.fecha == hoy).toList();
      },
      (error) => debugPrint(error),
    );

    return Future.value(citas);
  }
}
