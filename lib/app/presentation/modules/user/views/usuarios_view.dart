import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/usuario_row_widget.dart';
import 'usuario_detail_view.dart';

class UsuariosView extends StatefulWidget {
  const UsuariosView({super.key, required this.filterRol});

  final String filterRol;

  @override
  State<UsuariosView> createState() => _UsuariosViewState();
}

class _UsuariosViewState extends State<UsuariosView> {
  List<UsuarioModel> _usuarios = [];
  final StreamController<List<UsuarioModel>> _usuariosStream =
      StreamController();
  final _textNombreController = TextEditingController();
  final _textApellido1Controller = TextEditingController();
  final _textApellido2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    final UsuarioRepo repo = context.read();
    final usuarios = await repo.getAllUsuario();

    final result = usuarios.when(
      (success) => success,
      (error) => error,
    );
    if (result is List<UsuarioModel>) {
      final nombre = _textNombreController.text;
      final apellido1 = _textApellido1Controller.text;
      final apellido2 = _textApellido2Controller.text;

      _usuarios = result.where((r) => r.rol == widget.filterRol).toList();

      if (nombre.isNotEmpty) {
        _usuarios = _usuarios
            .where((u) => u.nombre != null && u.nombre!.contains(nombre.trim()))
            .toList();
      }

      if (apellido1.isNotEmpty) {
        _usuarios = _usuarios
            .where(
              (u) =>
                  u.apellido1 != null &&
                  u.apellido1!.contains(apellido1.trim()),
            )
            .toList();
      }

      if (apellido2.isNotEmpty) {
        _usuarios = _usuarios
            .where(
              (u) =>
                  u.apellido2 != null &&
                  u.apellido2!.contains(apellido2.trim()),
            )
            .toList();
      }
      _usuariosStream.add(_usuarios);
      debugPrint(_usuarios.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBarWidget(
        asset: 'assets/images/redela_logo.png',
        leading: IconButton(
          onPressed: () {
            navigateTo(Routes.admin, context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorConfig.secondary,
          ),
        ),
        backgroundColor: Colors.blueGrey[100],
        width: 90,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UsuarioDetailView(
          //       usuarioModel: ,
          //     ),
          //   ),
          // );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                TextFormWidget(
                  label: language.nombre,
                  keyboardType: TextInputType.text,
                  controller: _textNombreController,
                  onChanged: (value) {
                    _loadUsuarios();
                  },
                ),
                TextFormWidget(
                  label: language.apellido,
                  keyboardType: TextInputType.text,
                  controller: _textApellido1Controller,
                  onChanged: (value) {
                    _loadUsuarios();
                  },
                ),
                TextFormWidget(
                  label: language.apellido2,
                  keyboardType: TextInputType.text,
                  controller: _textApellido2Controller,
                  onChanged: (value) {
                    _loadUsuarios();
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _usuariosStream.stream,
                builder: (_, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (_, index) {
                            final usuarioModel = snapshot.data![index];

                            return UsuarioRowWidget(
                              usuarioModel: usuarioModel,
                            );
                          },
                          itemCount: snapshot.data!.length,
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
