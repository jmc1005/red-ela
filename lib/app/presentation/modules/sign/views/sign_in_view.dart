import 'package:flutter/material.dart';

import 'package:red_ela/app/presentation/modules/sign/views/sign_view.dart';
import 'package:red_ela/app/presentation/routes/app_routes.dart';
import 'package:red_ela/app/presentation/routes/routes.dart';

class SignInView extends StatefulWidget {
  SignInView({super.key});

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
