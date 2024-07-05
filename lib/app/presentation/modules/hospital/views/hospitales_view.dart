import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../config/color_config.dart';
import '../../../../domain/models/hospital/hospital_model.dart';
import '../../../../domain/repository/hospital_repo.dart';
import '../../../global/widgets/app_bar_widget.dart';
import '../../../global/widgets/sin_datos_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../widgets/hospital_row_widget.dart';
import 'hospital_detail_view.dart';

class HospitalesView extends StatefulWidget {
  const HospitalesView({super.key});

  @override
  State<HospitalesView> createState() => _HospitalesViewState();
}

class _HospitalesViewState extends State<HospitalesView> {
  List<HospitalModel> _hospitals = [];
  final _hospitalsStream = StreamController<List<HospitalModel>>();
  final _textSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHospitales();
  }

  Future<void> _loadHospitales() async {
    final HospitalRepo repo = context.read();
    final hospitals = await repo.getHospitales();

    final result = hospitals.when(
      (success) => success,
      (error) => error,
    );
    if (result is List<HospitalModel>) {
      final search = _textSearchController.text.toLowerCase();
      _hospitals = result;

      if (search.isNotEmpty) {
        _hospitals = result
            .where((r) => r.hospital.toLowerCase().contains(search.trim()))
            .toList();
      }

      _hospitalsStream.add(_hospitals);
      debugPrint(_hospitals.toString());
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
              builder: (context) => const HospitalDetailView(
                hospitalModel: null,
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
                _loadHospitales();
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
                  stream: _hospitalsStream.stream,
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (_, index) {
                              final hospitalModel = snapshot.data![index];

                              return HospitalRowWidget(
                                hospitalModel: hospitalModel,
                              );
                            },
                            itemCount: snapshot.data!.length,
                          )
                        : const SinDatosWidget();
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
