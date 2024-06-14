import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/tratamiento/tratamiento_model.dart';
import '../../../../domain/repository/tratamiento_repo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/tratamiento_row_widget.dart';
import 'tratamiento_detail_view.dart';

class TratamientosView extends StatefulWidget {
  const TratamientosView({super.key});

  @override
  State<TratamientosView> createState() => _TratamientosViewState();
}

class _TratamientosViewState extends State<TratamientosView> {
  List<TratamientoModel> _tratamientos = [];
  final _tratamientosStream = StreamController<List<TratamientoModel>>();
  final _textSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadTratamientos();
  }

  Future<void> _loadTratamientos() async {
    final TratamientoRepo repo = context.read();
    final tratamientos = await repo.getTratamientos();

    final result = tratamientos.when(
      (success) => success,
      (error) => error,
    );
    if (result is List<TratamientoModel>) {
      final search = _textSearchController.text.toLowerCase();
      _tratamientos = result;

      if (search.isNotEmpty) {
        _tratamientos = result
            .where((r) => r.tratamiento.toLowerCase().contains(search.trim()))
            .toList();
      }

      _tratamientosStream.add(_tratamientos);
      debugPrint(_tratamientos.toString());
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
              builder: (context) => const TratamientoDetailView(
                tratamientoModel: null,
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
                _loadTratamientos();
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
                  stream: _tratamientosStream.stream,
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (_, index) {
                              final tratamientoModel = snapshot.data![index];

                              return TratamientoRowWidget(
                                tratamientoModel: tratamientoModel,
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
