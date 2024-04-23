import 'package:flutter/material.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../controllers/usuario_controller.dart';
import '../views/usuario_detail_view.dart';
import 'usuario_item_widget.dart';

class UsuarioRowWidget extends StatefulWidget {
  const UsuarioRowWidget({
    super.key,
    required this.usuarioModel,
    required this.usuarioController,
  });

  final UsuarioModel usuarioModel;
  final UsuarioController usuarioController;

  @override
  State<UsuarioRowWidget> createState() => _UsuarioRowWidgetState();
}

class _UsuarioRowWidgetState extends State<UsuarioRowWidget> {
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
          child: UsuarioItemWidget(
            usuarioModel: widget.usuarioModel,
            onTap: () {
              widget.usuarioController.usuarioModel = widget.usuarioModel;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsuarioDetailView(
                    usuarioModel: widget.usuarioModel,
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
