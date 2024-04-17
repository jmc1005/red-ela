import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:red_ela/app/config/color_config.dart';
import 'package:red_ela/app/presentation/modules/admin/widgets/gestion_usuario_widget.dart';

import '../../../global/widgets/cabecera_widget.dart';
import '../../../global/widgets/item_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(Routes.signIn, context);
        },
        child: const Icon(
          Icons.exit_to_app,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 360,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 12,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/nodos.png',
                    width: 240,
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(
                              maxWidth: 360,
                            ),
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestionUsuarioWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
