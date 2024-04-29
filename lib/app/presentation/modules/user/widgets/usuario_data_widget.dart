import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../config/color_config.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/usuario_controller.dart';

class UsuarioDataWidget extends StatefulWidget with ValidatorMixin {
  UsuarioDataWidget({
    super.key,
    required this.usuarioController,
  });

  final UsuarioController usuarioController;

  @override
  State<UsuarioDataWidget> createState() => _UsuarioDataWidgetState();
}

class _UsuarioDataWidgetState extends State<UsuarioDataWidget> {
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuarioController = widget.usuarioController;
    final usuarioModel = usuarioController.state;

    final dateInput = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 3,
                  color: Color(0x33000000),
                  offset: Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorConfig.secondary,
                    radius: 50,
                    child: Text(
                      'Avatar',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ), //Text
                  ),
                  const SizedBox(height: 12),
                  TextFormWidget(
                    initialValue: usuarioModel?.nombre ?? '',
                    label: language.nombre,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      usuarioController.onChangeValueNombre(text);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormWidget(
                    initialValue: usuarioModel?.apellido1 ?? '',
                    label: language.apellido,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      usuarioController.onChangeValueApellido1(text);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormWidget(
                    initialValue: usuarioModel?.apellido2 ?? '',
                    label: language.apellido2,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      usuarioController.onChangeValueApellido2(text);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormWidget(
                    initialValue: usuarioModel?.email ?? '',
                    label: language.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) => widget.emailValidator(text, language),
                    onChanged: (text) {
                      usuarioController.onChangeValueEmail(text);
                    },
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (_) {
                      if (usuarioModel?.fechaNacimiento != null &&
                          usuarioModel!.fechaNacimiento.isNotEmpty) {
                        dateInput.text = usuarioModel.fechaNacimiento;
                      }

                      return TextFormField(
                        key: const Key('detailUserDateOfBirth'),
                        controller: dateInput,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text(language.fecha_nacimiento),
                          suffixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.calendar_today,
                            ),
                          ),
                        ),
                        onTap: () => usuarioController.openDatePicker(
                          context,
                          dateInput,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      usuarioController.update(context, language);
                    },
                    child: Text(
                      language.guardar,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
