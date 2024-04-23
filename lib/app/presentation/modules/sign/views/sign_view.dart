import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../domain/repository/connection_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../global/widgets/text_gesture_detector_widget.dart';
import '../controllers/sign_controller.dart';
import '../controllers/state/sign_state.dart';

class SignView extends StatefulWidget with ValidatorMixin {
  SignView({
    super.key,
    this.isSignIn = true,
    this.onTap,
  });

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

  var hasInternet = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ConnectionRepo connectionRepo = context.read();
    hasInternet = await connectionRepo.hasInternet;
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioRepo usuarioRepo = context.read();

    return ChangeNotifierProvider<SignController>(
      create: (context) => SignController(
        const SignState(),
        usuarioRepo: usuarioRepo,
      ),
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
                var validConfirmPassword = widget.isSignIn;

                if (!hasInternet) {
                  showTopSnackBar(Overlay.of(context),
                      CustomSnackBar.info(message: language.sin_conexion),
                      dismissType: DismissType.onSwipe,
                      dismissDirection: [DismissDirection.endToStart],
                      snackBarPosition: SnackBarPosition.bottom);
                }

                return ListView(
                  padding: const EdgeInsets.all(30),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/nodos.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormWidget(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      label: language.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) => widget.emailValidator(
                        text,
                        language,
                      ),
                      onChanged: (text) {
                        controller.onEmailChanged(text);
                      },
                    ),
                    const SizedBox(height: 20),
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
                      onChanged: (text) {
                        controller.onPasswordChanged(text);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(!obscurePassword
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
                    if (!widget.isSignIn) const SizedBox(height: 20),
                    if (!widget.isSignIn)
                      TextFormWidget(
                        controller: confirmPassController,
                        focusNode: confirmPassFocusNode,
                        label: language.confirmar_password,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          final validPassword = widget.passwordValidator(
                            value,
                            language,
                          );

                          final password = passController.text;

                          if (validPassword == null) {
                            validConfirmPassword =
                                password == confirmPassController.text;

                            if (!validConfirmPassword) {
                              return language.password_no_coincide;
                            }
                          }

                          return validPassword;
                        },
                        onChanged: (text) {
                          controller.onConfirmPasswordChanged(text);
                        },
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(!obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                              controller.onVisibilityConfirmPasswordChanged(
                                !obscureConfirmPassword,
                              );
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        controller.access(
                          isSignIn: widget.isSignIn,
                          context: context,
                          language: language,
                        );
                      },
                      child: Text(
                        widget.isSignIn
                            ? language.acceder
                            : language.registrarse,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
