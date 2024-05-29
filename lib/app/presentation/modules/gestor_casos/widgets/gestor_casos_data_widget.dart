import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/text_form_widget.dart';

class GestorCasosDataWidget extends StatefulWidget {
  const GestorCasosDataWidget({super.key});

  @override
  State<GestorCasosDataWidget> createState() => _GestorCasosDataWidgetState();
}

class _GestorCasosDataWidgetState extends State<GestorCasosDataWidget> {
  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of(context);
    final language = AppLocalizations.of(context)!;

    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormWidget(
        label: language.hospital,
        keyboardType: TextInputType.text,
        onChanged: (text) {},
        validator: (value) {},
      ),
    );
  }
}
