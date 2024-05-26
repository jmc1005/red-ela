import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:googleapis/admin/reports_v1.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/usuario_controller.dart';

class UsuarioDataWidget extends StatefulWidget with ValidatorMixin {
  UsuarioDataWidget({
    super.key,
    this.usuarioController,
  });

  final UsuarioController? usuarioController;

  @override
  State<UsuarioDataWidget> createState() => _UsuarioDataWidgetState();
}

class _UsuarioDataWidgetState extends State<UsuarioDataWidget> {
  final dateInput = TextEditingController();
  final passController = TextEditingController();
  final passFocusNode = FocusNode();
  final confirmPassController = TextEditingController();
  final confirmPassFocusNode = FocusNode();
  final phoneController = TextEditingController();

  var isEmailEmpty = false;
  var obscurePassword = true;
  var obscureConfirmPassword = true;
  var validConfirmPassword = true;
  var showPassword = false;

  @override
  void initState() {
    final usuarioController = widget.usuarioController;
    final usuario = usuarioController!.state!.usuario;

    isEmailEmpty = usuario.email != null && usuario.email!.isEmpty;
    visiblePassword(isEmailEmpty);

    super.initState();
  }

  Future<void> visiblePassword(isEmailEmpty) async {
    final usuarioController = widget.usuarioController;
    final usuario = usuarioController!.state!.usuario;

    final isMismo =
        usuario.uid == await usuarioController.sessionService.currentUid;

    showPassword = isEmailEmpty && isMismo;
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final usuarioController = widget.usuarioController;
    final usuario = usuarioController!.state!.usuario;
    phoneController.text = usuario.telefono ?? '';

    if (usuario.fechaNacimiento != null &&
        usuario.fechaNacimiento!.isNotEmpty) {
      dateInput.text = usuario.fechaNacimiento!;
    }

    return Column(
      children: [
        TextFormWidget(
          initialValue: usuario.nombre ?? '',
          label: language.nombre,
          keyboardType: TextInputType.text,
          validator: (value) => widget.textValidator(value, language),
          onChanged: (text) => usuarioController.onChangeValueNombre(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.apellido1 ?? '',
          label: language.apellido,
          keyboardType: TextInputType.text,
          validator: (value) => widget.textValidator(value, language),
          onChanged: (text) => usuarioController.onChangeValueApellido1(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.apellido2 ?? '',
          label: language.apellido2,
          keyboardType: TextInputType.text,
          validator: (value) => widget.textValidator(value, language),
          onChanged: (text) => usuarioController.onChangeValueApellido2(
            text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          label: language.telefono,
          keyboardType: TextInputType.phone,
          controller: phoneController,
          prefixText: '+34 ',
          validator: (value) => widget.phoneValidator(
            value,
            language,
          ),
          onChanged: (value) => usuarioController.onChangeValueTelefono(
            value,
          ),
        ),
        const SizedBox(height: 8),
        TextFormWidget(
          initialValue: usuario.email,
          label: language.email,
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
        ),
        if (showPassword)
          Column(
            children: [
              const SizedBox(height: 8),
              TextFormWidget(
                controller: passController,
                focusNode: passFocusNode,
                label: language.password,
                keyboardType: TextInputType.text,
                validator: (text) => widget.passwordValidator(
                  text,
                  language,
                ),
                obscureText: obscurePassword,
                onChanged: (text) => usuarioController.onPasswordChanged(
                  text,
                ),
                suffixIcon: IconButton(
                  icon: Icon(!obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextFormWidget(
                controller: confirmPassController,
                focusNode: confirmPassFocusNode,
                label: language.confirmar_password,
                keyboardType: TextInputType.text,
                validator: (value) => widget.passwordConfirmValidator(
                  value,
                  passController.text,
                  language,
                ),
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(!obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ],
          ),
        TextFormWidget(
          key: const Key('kFechaNacimiento'),
          controller: dateInput,
          label: language.fecha_nacimiento,
          keyboardType: TextInputType.datetime,
          suffixIcon: const Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.calendar_today,
            ),
          ),
          onTap: () => usuarioController.openDatePicker(
            context,
            dateInput,
          ),
        ),
      ],
    );
  }
}
