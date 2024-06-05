import 'package:flutter/material.dart';
import '../../../../domain/models/rol/rol_model.dart';
import '../views/rol_detail_view.dart';
import 'rol_item_widget.dart';

class RolRowWidget extends StatefulWidget {
  const RolRowWidget({
    super.key,
    required this.rolModel,
  });

  final RolModel rolModel;

  @override
  State<RolRowWidget> createState() => _RolRowWidgetState();
}

class _RolRowWidgetState extends State<RolRowWidget> {
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
          child: RolItemWidget(
            rolModel: widget.rolModel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RolDetailView(
                    rolModel: widget.rolModel,
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
