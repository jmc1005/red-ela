import 'package:flutter/material.dart';

class GestionWidget extends StatelessWidget {
  const GestionWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x33000000),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16,
            ),
            child: Column(
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
