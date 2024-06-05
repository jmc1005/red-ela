import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/citas/cita_model.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/cita_controller.dart';
import '../widgets/dropdown_pacientes_widget.dart';

Future<bool> showCitaDialog(
  BuildContext context, {
  required List<Widget> actions,
  required CitaModel cita,
  required CitaController citaController,
  bool readOnly = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.white.withOpacity(0.4), // cambiar la sombra
    barrierDismissible: false, // evitar cerrar popup al pulsar fuera del dialog
    builder: (context) => _DialogContent(
      actions: actions,
      cita: cita,
      readOnly: readOnly,
      citaController: citaController,
    ),
  );

  return result ?? false;
}

class _DialogContent extends StatefulWidget {
  const _DialogContent({
    required this.actions,
    required this.cita,
    required this.readOnly,
    required this.citaController,
  });

  final List<Widget> actions;
  final CitaController citaController;
  final CitaModel cita;
  final bool readOnly;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final _asunto = TextEditingController();
  final _fechaInicio = TextEditingController();
  final _horaInicio = TextEditingController();
  final _fechaFin = TextEditingController();
  final _horaFin = TextEditingController();
  final _notas = TextEditingController();
  final _lugar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final cita = widget.cita;

    _asunto.text = cita.asunto;
    _fechaInicio.text = cita.fechaInicio;
    _horaInicio.text = cita.horaInicio;
    _fechaFin.text = cita.fechaFin;
    _horaFin.text = cita.horaFin;
    _notas.text = cita.notas ?? '';
    _lugar.text = cita.lugar;

    return ChangeNotifierProvider<CitaController>(
      create: (_) => CitaController(),
      child: PopScope(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.8,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: TextFormWidget(
              controller: _asunto,
              label: language.asunto,
              keyboardType: TextInputType.text,
              readOnly: widget.readOnly,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!widget.readOnly)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownPacientesWidget(
                        citaController: widget.citaController,
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormWidget(
                        controller: _fechaInicio,
                        label: language.fecha_inicio,
                        keyboardType: TextInputType.text,
                        readOnly: widget.readOnly,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextFormWidget(
                        controller: _horaInicio,
                        label: language.hora_inicio,
                        keyboardType: TextInputType.text,
                        readOnly: widget.readOnly,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: TextFormWidget(
                        controller: _fechaFin,
                        label: language.fecha_fin,
                        keyboardType: TextInputType.text,
                        readOnly: widget.readOnly,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextFormWidget(
                        controller: _horaFin,
                        label: language.hora_fin,
                        keyboardType: TextInputType.text,
                        readOnly: widget.readOnly,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormWidget(
                  controller: _lugar,
                  label: language.lugar,
                  keyboardType: TextInputType.text,
                  readOnly: widget.readOnly,
                ),
                const SizedBox(height: 8),
                TextFormWidget(
                  controller: _notas,
                  label: language.notas,
                  keyboardType: TextInputType.text,
                  readOnly: widget.readOnly,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ), // cambiar el borde radius
            actionsAlignment: MainAxisAlignment.center,
            actions: widget.actions,
          ),
        ),
        onPopInvoked: (didPop) => false,
      ),
    );
  }
}
