import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repository/usuario_repo.dart';
import '../../../global/widgets/tarjeta_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/gestion_hospital_widget.dart';
import '../widgets/gestion_rol_widget.dart';
import '../widgets/gestion_tratamiento_widget.dart';
import '../widgets/gestion_usuario_widget.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    final usuarioRepo = Provider.of<UsuarioRepo>(context);

    return TarjetaWidget(
      onPressed: () {
        usuarioRepo.signOut();
        navigateTo(Routes.signIn, context);
      },
      children: const [
        GestionUsuarioWidget(),
        GestionRolWidget(),
        GestionHospitalWidget(),
        GestionTratamientoWidget(),
      ],
    );
  }
}
