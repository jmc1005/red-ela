import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/usuario_data_widget.dart';

class UsuarioDetailView extends StatelessWidget {
  const UsuarioDetailView({super.key, required this.usuarioModel});

  final UsuarioModel usuarioModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(
        usuarioRepo: context.read(),
      ),
      child: Scaffold(
        appBar: AppBarWidget(
          asset: 'images/nodos.png',
          backgroundColor: ColorConfig.primary,
          leading: IconButton(
            onPressed: () {
              navigateTo(Routes.userList, context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConfig.secondary,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(child: Builder(
            builder: (BuildContext context) {
              final UsuarioController usuarioController = context.read();
              usuarioController.usuarioModel = usuarioModel;

              return UsuarioDataWidget(usuarioController: usuarioController);
            },
          )),
        ),
      ),
    );
  }
}
