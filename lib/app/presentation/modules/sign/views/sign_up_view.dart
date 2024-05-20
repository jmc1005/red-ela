import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import 'sign_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  void _onTap() {
    navigateTo(Routes.signIn, context);
  }

  @override
  Widget build(BuildContext context) {
    return SignView(
      onTap: _onTap,
    );
  }
}
