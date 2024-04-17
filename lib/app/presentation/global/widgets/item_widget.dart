import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.label, this.onTap});

  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 1),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE5E7EB),
                offset: Offset(0, 1),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF15161E),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF606A85),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
