import 'package:flutter/material.dart';
import '../../../../domain/models/tratamiento/tratamiento_model.dart';
import '../views/tratamiento_detail_view.dart';
import 'tratamiento_item_widget.dart';

class TratamientoRowWidget extends StatefulWidget {
  const TratamientoRowWidget({
    super.key,
    required this.tratamientoModel,
  });

  final TratamientoModel tratamientoModel;

  @override
  State<TratamientoRowWidget> createState() => _TratamientoRowWidgetState();
}

class _TratamientoRowWidgetState extends State<TratamientoRowWidget> {
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
          child: TratamientoItemWidget(
            tratamientoModel: widget.tratamientoModel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TratamientoDetailView(
                    tratamientoModel: widget.tratamientoModel,
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
