import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class AccordionWidget extends StatelessWidget {
  const AccordionWidget({super.key, required this.children});

  final List<AccordionSection> children;

  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerPadding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 15,
      ),
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      children: children,
    );
  }
}
