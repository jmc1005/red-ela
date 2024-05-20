import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class CuidadorDataWidget extends StatefulWidget with ValidatorMixin {
  CuidadorDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<CuidadorDataWidget> createState() => _CuidadorDataWidgetState();
}

class _CuidadorDataWidgetState extends State<CuidadorDataWidget> {
  final FocusNode relacionFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8,
          ),
          TextFormWidget(
            label: language.relacion,
            keyboardType: TextInputType.text,
            focusNode: relacionFocus,
            onChanged: (text) => controller.onChangeRelacion(text),
            validator: (value) => widget.textValidator(
              value,
              language,
            ),
          ),
        ],
      ),
    );
  }
}
