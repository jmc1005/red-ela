import 'package:multiple_result/multiple_result.dart';

import '../models/invitacion/invitacion_model.dart';

abstract class InvitacionRepo {
  Future<Result<InvitacionModel, dynamic>> getInvitacion(String telefono);

  Future<Result<dynamic, dynamic>> addInvitacion(
    String telefono,
    String rol,
    String solicitado,
  );

  Future<Result<dynamic, dynamic>> updateInvitacion(
    String telefono,
    String estado,
  );
}
