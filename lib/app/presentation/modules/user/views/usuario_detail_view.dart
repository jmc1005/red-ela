import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/walletobjects/v1.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/usuario_data_widget.dart';

class UsuarioDetailView extends StatefulWidget {
  const UsuarioDetailView({
    super.key,
    required this.usuarioModel,
  });

  final UsuarioModel usuarioModel;

  @override
  State<UsuarioDetailView> createState() => _UsuarioDetailViewState();
}

class _UsuarioDetailViewState extends State<UsuarioDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(
        usuarioRepo: context.read(),
        context: context,
      ),
      child: Scaffold(
        appBar: AppBarWidget(
          asset: 'images/redela_logo.png',
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
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              final UsuarioController usuarioController = context.read();
              usuarioController.usuario = widget.usuarioModel;

              return Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      backgroundColor: ColorConfig.secondary,
                      radius: 50,
                      child: Text(
                        'Avatar',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ), //Text
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: Wrap(
                        children: [
                          UsuarioDataWidget(
                            usuarioController: usuarioController,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
