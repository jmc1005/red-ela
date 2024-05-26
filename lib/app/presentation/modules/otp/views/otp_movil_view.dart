import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../global/widgets/text_gesture_detector_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/otp_controller.dart';
import '../controllers/state/otp_state.dart';

class OTPMovilView extends StatefulWidget with ValidatorMixin {
  OTPMovilView({super.key});

  @override
  State<OTPMovilView> createState() => _OTPMovilViewState();
}

class _OTPMovilViewState extends State<OTPMovilView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otp = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<OTPController>(
      create: (_) => OTPController(
        const OTPState(),
        usuarioRepo: context.read(),
        invitacionRepo: context.read(),
        pacienteRepo: context.read(),
        cuidadorRepo: context.read(),
        gestorCasosRepo: context.read(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: _formKey,
                child: Builder(builder: (context) {
                  final OTPController otpController = context.read();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 20,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/redela_logo.png'),
                          ),
                        ),
                      ),
                      Text(
                        language.infoInvitacion,
                        maxLines: 3,
                        overflow: TextOverflow
                            .ellipsis, // añade los tres puntos cuando no muestra
                        // overflow: TextOverflow.fade, // añade sombra
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: ColorConfig.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextFormWidget(
                        //initialValue: otpController.state.phoneNumber,
                        label: language.telefono,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        prefixText: '+34 ',
                        validator: (value) => widget.phoneValidator(
                          value,
                          language,
                        ),
                        onChanged: (value) => otpController.changePhoneNumber(
                          value,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SubmitButtonWidget(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final invitacion = await otpController
                                .obtenerInvitacion(phoneController.text);

                            invitacion.when(
                              (success) async {
                                if (success.estado == 'pendiente') {
                                  await otpController.enviarOTP(
                                    phoneNumber: phoneController.text,
                                    rol: success.rol,
                                    solicitado: success.solicitado,
                                    context: context,
                                  );
                                } else {
                                  otpController.showWarning(
                                      FirebaseCode.userRegistered,
                                      language,
                                      context);
                                }
                              },
                              (error) => otpController.showError(
                                error,
                                language,
                                context,
                              ),
                            );
                          }
                        },
                        label: language.enviar_codigo,
                      ),
                      TextGestureDetectorWidget(
                        onTap: () => navigateTo(Routes.signIn, context),
                        pregunta: language.tienes_cuenta,
                        tapString: language.acceder,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
