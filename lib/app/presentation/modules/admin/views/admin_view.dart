import 'package:flutter/material.dart';

import '../../../global/widgets/tarjeta_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/gestion_usuario_widget.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return TarjetaWidget(
      onPressed: () => navigateTo(Routes.signIn, context),
      children: const [
        GestionUsuarioWidget(),
      ],
    );
  }
}
