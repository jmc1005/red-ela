import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  var hasEmail = false;
  var obscurePassword = true;
  var obscureConfirmPassword = true;
  var validConfirmPassword = true;

  @override
  void initState() {
    final usuarioController = widget.usuarioController;
    final usuario = usuarioController!.state!.usuario;

    hasEmail = usuario.email != null && usuario.email!.isNotEmpty;

    super.initState();
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
          validator: (text) => widget.emailValidator(text, language),
          onChanged: (text) => usuarioController.onChangeValueEmail(
            text,
          ),
        ),
        if (!hasEmail) const SizedBox(height: 8),
        if (!hasEmail)
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
              icon: Icon(
                  !obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
        if (!hasEmail) const SizedBox(height: 8),
        if (!hasEmail)
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
        const SizedBox(height: 8),
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
