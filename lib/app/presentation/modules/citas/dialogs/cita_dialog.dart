import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/citas/cita_model.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../global/widgets/text_gesture_detector_widget.dart';
import '../controllers/cita_controller.dart';
import '../widgets/dropdown_pacientes_widget.dart';

Future<bool> showCitaDialog(
  BuildContext context, {
  required List<Widget> actions,
  required CitaModel cita,
  required CitaController citaController,
  required GlobalKey<FormState> formKey,
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
      formKey: formKey,
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
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final List<Widget> actions;
  final CitaController citaController;
  final CitaModel cita;
  final bool readOnly;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> with ValidatorMixin {
  final _asunto = TextEditingController();
  final _fechaInicio = TextEditingController();
  final _horaInicio = TextEditingController();
  final _horaFin = TextEditingController();
  final _notas = TextEditingController();
  final _lugar = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initCita();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    _asunto.text = widget.citaController.state!.asunto;
    _fechaInicio.text = widget.citaController.state!.fechaInicio;
    _horaInicio.text = widget.citaController.state!.horaInicio;
    _horaFin.text = widget.citaController.state!.horaFin;
    _lugar.text = widget.citaController.state!.lugar;
    _notas.text = widget.citaController.state!.notas ?? '';

    return ChangeNotifierProvider<CitaController>(
      create: (_) => CitaController(),
      child: PopScope(
        child: AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormWidget(
                    controller: _asunto,
                    label: language.asunto,
                    keyboardType: TextInputType.text,
                    readOnly: widget.readOnly,
                    validator: !widget.readOnly
                        ? (value) => textValidator(
                              value,
                              language,
                            )
                        : null,
                    onChanged: !widget.readOnly
                        ? (text) => widget.citaController.onChangeAsunto(text)
                        : null,
                  ),
                  const Divider(
                    height: 24,
                    thickness: 2,
                    color: Color(0xFFF1F4F8),
                  ),
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
                          key: const Key('kFechaInicio'),
                          controller: _fechaInicio,
                          label: language.fecha_inicio,
                          keyboardType: TextInputType.text,
                          readOnly: widget.readOnly,
                          suffixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.calendar_today,
                            ),
                          ),
                          validator: !widget.readOnly
                              ? (value) => textValidator(
                                    value,
                                    language,
                                  )
                              : null,
                          onTap: !widget.readOnly
                              ? () => widget.citaController
                                      .openDatePickerFechaInicio(
                                    context,
                                    _fechaInicio,
                                  )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormWidget(
                          key: const Key('kHoraInicio'),
                          controller: _horaInicio,
                          label: language.hora_inicio,
                          keyboardType: TextInputType.text,
                          readOnly: widget.readOnly,
                          suffixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.schedule,
                            ),
                          ),
                          validator: !widget.readOnly
                              ? (value) => textValidator(
                                    value,
                                    language,
                                  )
                              : null,
                          onTap: !widget.readOnly
                              ? () => widget.citaController
                                      .openTimePickerHoraInicio(
                                    context,
                                    _horaInicio,
                                  )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextFormWidget(
                          key: const Key('kHoraFin'),
                          controller: _horaFin,
                          label: language.hora_fin,
                          keyboardType: TextInputType.text,
                          readOnly: widget.readOnly,
                          suffixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.schedule,
                            ),
                          ),
                          validator: !widget.readOnly
                              ? (value) => textValidator(
                                    value,
                                    language,
                                  )
                              : null,
                          onTap: !widget.readOnly
                              ? () =>
                                  widget.citaController.openTimePickerHoraFin(
                                    context,
                                    _horaFin,
                                  )
                              : null,
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
                    validator: !widget.readOnly
                        ? (value) => textValidator(
                              value,
                              language,
                            )
                        : null,
                    onChanged: !widget.readOnly
                        ? (text) => widget.citaController.onChangeLugar(text)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormWidget(
                    controller: _notas,
                    label: language.notas,
                    keyboardType: TextInputType.text,
                    readOnly: widget.readOnly,
                    onChanged: !widget.readOnly
                        ? (text) => widget.citaController.onChangeNotas(text)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextGestureDetectorWidget(
                    onTap: () {
                      widget.citaController.cancelarCita();
                    },
                    tapString: '${language.cancelar} ${language.cita}',
                  ),
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ), // cambiar el borde radius
          actionsAlignment: MainAxisAlignment.center,
          actions: widget.actions,
        ),
        onPopInvoked: (didPop) => false,
      ),
    );
  }

  void _initCita() {
    final cita = widget.cita;

    _asunto.text = cita.asunto;
    _fechaInicio.text = cita.fechaInicio;
    _horaInicio.text = cita.horaInicio;
    _horaFin.text = cita.horaFin;
    _notas.text = cita.notas ?? '';
    _lugar.text = cita.lugar;
  }
}
