import 'package:flutter/material.dart';
import 'package:red_ela/app/presentation/modules/sign/views/sign_in_view.dart';
import 'package:red_ela/app/presentation/modules/sign/views/sign_out_view.dart';

import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.signIn: (context) => SignInView(),
    Routes.signOut: (context) => SignOutView(),
  };
}

Future<void> navigateTo(String route, BuildContext context) {
  return Navigator.pushReplacementNamed(
    context,
    route,
  );
}
