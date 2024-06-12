import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.label,
    this.onChanged,
    required this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.focusNode,
    this.suffixIcon,
    this.controller,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
    this.prefixText,
  });

  final String label;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? initialValue;
  final Function()? onTap;
  final bool readOnly;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          label: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
          suffixIcon: suffixIcon,
          prefixText: prefixText,
        ),
        validator: validator,
        obscureText: obscureText,
        focusNode: focusNode,
        onTap: onTap,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  /*

  suffixIcon: InkWell(
          onTap: () => setState(
            () => _model.passwordVisibility = !_model.passwordVisibility,
          ),
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            _model.passwordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24,
          ),
        ),
   */
}
