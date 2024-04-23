import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/usuario_row_widget.dart';

class UsuariosView extends StatefulWidget {
  const UsuariosView({super.key});

  @override
  State<UsuariosView> createState() => _UsuariosViewState();
}

class _UsuariosViewState extends State<UsuariosView> {
  late final Future<List<UsuarioModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _init();
  }

  Future<List<UsuarioModel>> _init() async {
    final List<UsuarioModel> usuarios = [];

    usuarios.add(const UsuarioModel(
      'uid',
      'nombre',
      'apellido1',
      'apellido2',
      'email@prueba.com',
      ['admin', 'gestor'],
    ));

    return usuarios;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(),
      child: Builder(builder: (context) {
        final usuarioController = Provider.of<UsuarioController>(context);

        return Scaffold(
          appBar: AppBarWidget(
            asset: 'images/nodos.png',
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
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ArticleDetailView(
              //       editMode: editMode,
              //     ),
              //   ),
              // );
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: _future,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (_, index) {
                            final usuarioModel = snapshot.data![index];
                            return UsuarioRowWidget(
                              usuarioModel: usuarioModel,
                              usuarioController: usuarioController,
                            );
                          },
                          itemCount: snapshot.data!.length,
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return const Text('Error');
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
      }),
    );
  }
}
