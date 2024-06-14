import 'package:flutter/material.dart';
import '../../../../domain/models/hospital/hospital_model.dart';
import '../views/hospital_detail_view.dart';
import 'hospital_item_widget.dart';

class HospitalRowWidget extends StatefulWidget {
  const HospitalRowWidget({
    super.key,
    required this.hospitalModel,
  });

  final HospitalModel hospitalModel;

  @override
  State<HospitalRowWidget> createState() => _HospitalRowWidgetState();
}

class _HospitalRowWidgetState extends State<HospitalRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Container(
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
          padding: const EdgeInsets.all(12.0),
          child: HospitalItemWidget(
            hospitalModel: widget.hospitalModel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HospitalDetailView(
                    hospitalModel: widget.hospitalModel,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
