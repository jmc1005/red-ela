import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
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
  late final Future<Result<List<UsuarioModel>, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _init();
  }

  Future<Result<List<UsuarioModel>, dynamic>> _init() async {
    final UsuarioRepo repo = context.read();
    return repo.getAllUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsuarioController>(
      create: (_) => UsuarioController(
        usuarioRepo: context.read(),
      ),
      child: Builder(builder: (context) {
        final usuarioController = Provider.of<UsuarioController>(context);
        final language = AppLocalizations.of(context)!;

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
                        final data = snapshot.data!;

                        var result = data.when(
                          (success) => success,
                          (error) => error,
                        );

                        if (result is List<UsuarioModel>) {
                          return ListView.builder(
                            itemBuilder: (_, index) {
                              final usuarioModel = result[index];
                              return UsuarioRowWidget(
                                usuarioModel: usuarioModel,
                                usuarioController: usuarioController,
                              );
                            },
                            itemCount: result.length,
                          );
                        }
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
