import 'package:flutter/material.dart';

import '../../../../domain/repository/cuidador_repo.dart';

class CuidadorController {
  CuidadorController({
    required this.context,
    required this.cuidadorRepo,
  });

  final BuildContext context;
  final CuidadorRepo cuidadorRepo;
}
