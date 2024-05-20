import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/snackBar/snackbar_util.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../controllers/otp_controller.dart';

class OTPCodigoWidget extends StatefulWidget with ValidatorMixin {
  OTPCodigoWidget({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.rol,
  });

  final String phoneNumber;
  final String rol;
  final String verificationId;

  @override
  State<OTPCodigoWidget> createState() => _OTPCodigoWidgetState();
}

class _OTPCodigoWidgetState extends State<OTPCodigoWidget> {
  String codigo = '';

  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color primaryColor = const Color(0xFF121212);
  Color accentPinkColor = const Color(0xFFF99BBD);
  Color accentDarkGreenColor = const Color(0xFF115C49);
  Color accentYellowColor = const Color(0xFFFFB612);
  Color accentOrangeColor = const Color(0xFFEA7A3B);

  TextStyle? createStyle(Color color) {
    final theme = Theme.of(context);
    return theme.textTheme.displayMedium?.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final OTPController otpController = context.read();

    final otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                TextFormWidget(
                  initialValue: widget.phoneNumber,
                  label: language.telefono,
                  keyboardType: TextInputType.phone,
                  prefixText: '+34 ',
                  readOnly: true,
                ),
                OtpTextField(
                  numberOfFields: 6,
                  autoFocus: true,
                  borderColor: accentPurpleColor,
                  focusedBorderColor: accentPurpleColor,
                  styles: otpTextStyles,
                  borderWidth: 4.0,
                  onCodeChanged: (String code) {},
                  onSubmit: (String verificationCode) {
                    debugPrint('Código $verificationCode');
                    codigo = verificationCode;
                  },
                  disabledBorderColor: Colors.white10,
                ),
                const SizedBox(height: 30),
                SubmitButtonWidget(
                  onPressed: () {
                    if (codigo.length == 6) {
                      otpController.confirmar(
                        phoneNumber: widget.phoneNumber,
                        rol: widget.rol,
                        codigo: codigo,
                        verificationId: widget.verificationId,
                        language: language,
                        context: context,
                      );
                    } else {
                      final snackbarUtil = SnackBarUtils(
                        context: context,
                        message: language.numero_invalido,
                      );
                      snackbarUtil.showWarning();
                    }
                  },
                  label: language.confirmar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
