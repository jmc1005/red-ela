import 'package:multiple_result/multiple_result.dart';

import '../models/invitacion/invitacion_model.dart';

abstract class InvitacionRepo {
  Future<Result<InvitacionModel, dynamic>> getInvitacion(String telefono);

  Future<Result<dynamic, dynamic>> addInvitacion({
    required String telefono,
    required String rol,
  });

  Future<Result<dynamic, dynamic>> updateInvitacion(
    String telefono,
    String estado,
  );
}
