import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class AccordionWidget extends StatelessWidget {
  const AccordionWidget({super.key, required this.children});

  final List<AccordionSection> children;

  @override
  Widget build(BuildContext context) {
    return Accordion(children: children);
  }
}
