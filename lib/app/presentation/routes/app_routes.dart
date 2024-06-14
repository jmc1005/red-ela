import 'package:flutter/material.dart';

import '../modules/admin/views/admin_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hospital/views/hospitales_view.dart';
import '../modules/otp/views/otp_movil_view.dart';
import '../modules/rol/views/roles_view.dart';
import '../modules/sign/views/sign_in_view.dart';
import '../modules/sign/views/sign_up_view.dart';

import '../modules/tratamiento/views/tratamientos_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.signIn: (_) => const SignInView(),
    Routes.signUp: (_) => const SignUpView(),
    Routes.admin: (_) => const AdminView(),
    Routes.sendOTP: (_) => OTPMovilView(),
    Routes.rolList: (_) => const RolesView(),
    Routes.hospitalList: (_) => const HospitalesView(),
    Routes.tratamientoList: (_) => const TratamientosView(),
    Routes.home: (_) => const HomeView(),
  };
}

Route<dynamic> generateRoute(RouteSettings settings) {
  debugPrint('settings $settings');

  final routeName = settings.name;
  if (routeName != null) {
    if (routeName.isEmpty || routeName == Routes.signIn) {
      return MaterialPageRoute(builder: (_) => const SignInView());
    } else if (routeName == Routes.admin) {
      return MaterialPageRoute(builder: (_) => const AdminView());
    } else if (routeName == Routes.sendOTP) {
      return MaterialPageRoute(builder: (_) => OTPMovilView());
    } else if (routeName == Routes.rolList) {
      return MaterialPageRoute(builder: (_) => const RolesView());
    } else if (routeName == Routes.tratamientoList) {
      return MaterialPageRoute(builder: (_) => const TratamientosView());
    } else if (routeName == Routes.hospitalList) {
      return MaterialPageRoute(builder: (_) => const HospitalesView());
    } else if (routeName == Routes.home) {
      return MaterialPageRoute(builder: (_) => const HomeView());
    }
  }

  return MaterialPageRoute(
      builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ));
}

Future<void> navigateTo(String route, BuildContext context) {
  return Navigator.pushReplacementNamed(
    context,
    route,
  );
}
