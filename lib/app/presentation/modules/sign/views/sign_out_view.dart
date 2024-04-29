import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import 'sign_view.dart';

class SignOutView extends StatefulWidget {
  const SignOutView({super.key});

  @override
  State<SignOutView> createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> {
  final _formKey = GlobalKey<FormState>();

  _onTap() {
    if (_formKey.currentState!.validate()) {
      navigateTo(Routes.signIn, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignView(
      isSignIn: false,
      onTap: _onTap,
      formKey: _formKey,
    );
  }
}
