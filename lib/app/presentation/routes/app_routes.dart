import 'package:flutter/material.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/sign/views/sign_in_view.dart';
import '../modules/sign/views/sign_up_view.dart';
import '../modules/user/views/usuarios_view.dart';

import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.signIn: (context) => const SignInView(),
    Routes.signOut: (context) => const SignUpView(),
    Routes.admin: (context) => const AdminView(),
    Routes.userList: (context) => const UsuariosView()
  };
}

Future<void> navigateTo(String route, BuildContext context) {
  return Navigator.pushReplacementNamed(
    context,
    route,
  );
}
