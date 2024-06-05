import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/rol/rol_model.dart';
import '../../../../domain/repository/rol_repo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/rol_row_widget.dart';
import 'rol_detail_view.dart';

class RolesView extends StatefulWidget {
  const RolesView({super.key});

  @override
  State<RolesView> createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  List<RolModel> _roles = [];
  final _rolesStream = StreamController<List<RolModel>>();
  final _textSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final RolRepo repo = context.read();
    final roles = await repo.getRoles();

    final result = roles.when(
      (success) => success,
      (error) => error,
    );
    if (result is List<RolModel>) {
      final search = _textSearchController.text.toLowerCase();
      _roles = result;

      if (search.isNotEmpty) {
        _roles = result
            .where((r) => r.descripcion.toLowerCase().contains(search.trim()))
            .toList();
      }

      _rolesStream.add(_roles);
      debugPrint(_roles.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

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
        width: 80,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RolDetailView(
                rolModel: null,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormWidget(
              label: language.buscar,
              keyboardType: TextInputType.text,
              controller: _textSearchController,
              onChanged: (value) {
                _loadRoles();
              },
              suffixIcon: const Icon(Icons.search),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SizedBox(
                height: size.height,
                child: StreamBuilder(
                  stream: _rolesStream.stream,
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (_, index) {
                              final rolModel = snapshot.data![index];

                              return RolRowWidget(
                                rolModel: rolModel,
                              );
                            },
                            itemCount: snapshot.data!.length,
                          )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
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
