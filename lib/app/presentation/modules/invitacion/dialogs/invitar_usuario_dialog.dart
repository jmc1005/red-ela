import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/invitacion/invitacion_model.dart';
import '../../../../domain/repository/invitacion_repo.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/invitacion_controller.dart';
import '../controllers/state/invitacion_state.dart';

Future<bool> showInvitarUsuarioDialog(
  BuildContext context, {
  required String rol,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.white.withOpacity(0.4), // cambiar la sombra
    barrierDismissible: false, // evitar cerrar popup al pulsar fuera del dialog
    builder: (context) => _DialogContent(
      rol: rol,
    ),
  );

  return result ?? false;
}

class _DialogContent extends StatefulWidget with ValidatorMixin {
  _DialogContent({
    required this.rol,
  });

  final String rol;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final phoneNumberController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();
  InvitacionModel? invitacionModel;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getInvitacion(telefono) async {
    final InvitacionController invitacionController = context.read();

    invitacionModel = null;
    final response =
        await invitacionController.invitacionRepo.getInvitacion(telefono);

    response.when(
      (success) => invitacionModel = success,
      (error) => debugPrint(error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final InvitacionController invitacionController = context.read();
    final invitacionRepo = invitacionController.invitacionRepo;
    final invitacion = invitacionController.state;
    final size = MediaQuery.of(context).size;

    emailController.text = invitacion.email;
    phoneNumberController.text = invitacion.telefono;

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
        onPressed: () async {
          final ctx = context;
          if (_formKey.currentState!.validate()) {
            getInvitacion(invitacionController.state.telefono);

            if (invitacionModel == null) {
              await invitacionController.sendEmailPhone(ctx, language);

              invitacionRepo.addInvitacion(
                telefono: invitacionController.state.telefono,
                rol: invitacionController.state.rol,
              );
            } else {
              debugPrint('Ya existe invitación enviada');
              invitacionController.showError(
                context,
                language.invitacion_ya_existe,
              );
              // buscar usuario por email y asignarlo
            }
          }
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

    return ChangeNotifierProvider<InvitacionController>(
      create: (_) => InvitacionController(
        const InvitacionState(),
        invitacionRepo: context.read(),
        usuarioRepo: context.read(),
      ),
      child: PopScope(
        child: AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: size.width / 1.1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    language.info_envio_email,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: FutureBuilder(
                      future: invitacionController.getRoles(context),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          final size = MediaQuery.of(context).size;

                          data.when(
                            (success) => invitacionController.roles = success,
                            (error) => null,
                          );

                          if (invitacionController.roles.isNotEmpty) {
                            invitacionController.filtrarRoles(widget.rol);
                            invitacionController.setItems(size.width, language);
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: size.width / 1.1,
                                child: TextFormWidget(
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  label: language.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (text) => widget.emailValidator(
                                    text,
                                    language,
                                  ),
                                  onChanged: (text) {
                                    invitacionController.onChangeEmail(text);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: size.width / 1.1,
                                child: TextFormWidget(
                                  controller: phoneNumberController,
                                  focusNode: phoneNumberFocusNode,
                                  label: language.telefono,
                                  keyboardType: TextInputType.phone,
                                  prefixText: '+34 ',
                                  validator: (text) => widget.phoneValidator(
                                    text,
                                    language,
                                  ),
                                  onChanged: (text) {
                                    invitacionController.onChangeTelefono(text);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: size.width / 1.1,
                                child: DropdownButtonFormField(
                                  value: invitacionController.state.rol,
                                  decoration: InputDecoration(
                                    label: Text(language.roles),
                                  ),
                                  items: invitacionController.items,
                                  onChanged: (text) {
                                    if (text != null) {
                                      invitacionController.onChangeRol(text);
                                    }
                                  },
                                  isExpanded: true,
                                  validator: (value) =>
                                      widget.textValidator(value, language),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ), // cambiar el borde radius
          actionsAlignment: MainAxisAlignment.center,
          actions: actions,
        ),
        onPopInvoked: (didPop) => false,
      ),
    );
  }
}
