import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextGestureDetectorWidget extends StatelessWidget {
  const TextGestureDetectorWidget({
    super.key,
    this.recognizer,
    required this.pregunta,
    required this.tapString,
    required this.onTap,
  });

  final GestureRecognizer? recognizer;
  final String pregunta;
  final String tapString;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(pregunta, textAlign: TextAlign.center),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              tapString,
              style: const TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
