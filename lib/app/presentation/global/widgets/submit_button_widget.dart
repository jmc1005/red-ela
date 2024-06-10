import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key, required this.label, this.onPressed});

  final String label;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
