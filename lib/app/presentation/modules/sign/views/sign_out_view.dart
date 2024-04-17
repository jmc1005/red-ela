import 'package:flutter/material.dart';

import 'package:red_ela/app/presentation/modules/sign/views/sign_view.dart';
import 'package:red_ela/app/presentation/routes/app_routes.dart';
import 'package:red_ela/app/presentation/routes/routes.dart';

class SignOutView extends StatefulWidget {
  SignOutView({super.key});

  @override
  State<SignOutView> createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> {
  _onTap() {
    navigateTo(Routes.signIn, context);
  }

  @override
  Widget build(BuildContext context) {
    return SignView(
      isSignIn: false,
      onTap: _onTap,
    );
  }
}
