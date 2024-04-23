import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import 'sign_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  _onTap() {
    navigateTo(Routes.signOut, context);
  }

  @override
  Widget build(BuildContext context) {
    return SignView(
      onTap: _onTap,
    );
  }
}
