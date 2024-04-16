import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_ela/app/presentation/global/widgets/text_gesture_detector_widget.dart';
import 'package:red_ela/app/presentation/global/widgets/text_form_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_ela/app/presentation/modules/sign/controllers/sign_controller.dart';
import 'package:red_ela/app/presentation/modules/sign/controllers/state/sign_state.dart';
import 'package:red_ela/app/utils/validators/validator_mixin.dart';

class SignView extends StatefulWidget with ValidatorMixin {
  SignView({super.key, this.isSignIn = true, this.onTap});

  final bool isSignIn;
  final Function()? onTap;

  @override
  State<SignView> createState() => _SignViewState();
}

class _SignViewState extends State<SignView> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final passController = TextEditingController();
  final passFocusNode = FocusNode();

  final confirmPassController = TextEditingController();
  final confirmPassFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignController>(
      create: (context) => SignController(const SignState()),
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Builder(
              builder: (context) {
                final controller = Provider.of<SignController>(context);
                final language = AppLocalizations.of(context)!;
                var obscurePassword = controller.state.obscurePassword;
                var obscureConfirmPassword =
                    controller.state.obscureConfirmPassword;

                return ListView(
                  padding: EdgeInsets.all(30),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/nodos.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormWidget(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      label: language.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) =>
                          widget.emailValidator(text, language),
                      onChanged: (text) {
                        controller.onEmailChanged(text);
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormWidget(
                      controller: passController,
                      focusNode: passFocusNode,
                      label: language.password,
                      keyboardType: TextInputType.text,
                      validator: (text) =>
                          widget.passwordValidator(text, language),
                      obscureText: controller.state.obscurePassword,
                      onChanged: (text) {
                        controller.onPasswordChanged(text);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(!controller.state.obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;

                            controller.onVisibilityPasswordChanged(
                              obscurePassword,
                            );
                          });
                        },
                      ),
                    ),
                    if (!widget.isSignIn) const SizedBox(height: 30),
                    if (!widget.isSignIn)
                      TextFormWidget(
                        controller: confirmPassController,
                        focusNode: confirmPassFocusNode,
                        label: language.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final validPassword = widget.passwordValidator(
                            value,
                            language,
                          );
                          final password = passController.text;

                          if (validPassword == null) {
                            if (password != confirmPassController.text) {
                              return language.password_no_coincide;
                            }
                          }

                          return validPassword;
                        },
                        obscureText: controller.state.obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(!controller.state.obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                              controller.onVisibilityConfirmPasswordChanged(
                                !controller.state.obscureConfirmPassword,
                              );
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          debugPrint('Acceder/Registrarse');
                        },
                        child: Text(
                          widget.isSignIn
                              ? language.acceder
                              : language.registrarse,
                        )),
                    TextGestureDetectorWidget(
                      onTap: widget.onTap,
                      pregunta: widget.isSignIn
                          ? language.no_tienes_cuenta
                          : language.tienes_cuenta,
                      tapString: widget.isSignIn
                          ? language.registrarse
                          : language.acceder,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
