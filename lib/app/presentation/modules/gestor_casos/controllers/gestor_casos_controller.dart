import 'package:flutter/material.dart';

import '../../../../domain/repository/gestor_casos_repo.dart';

class GestorCasosController {
  GestorCasosController({
    required this.context,
    required this.gestorCasosRepo,
  });

  final BuildContext context;
  final GestorCasosRepo gestorCasosRepo;
}
