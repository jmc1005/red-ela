import 'package:multiple_result/multiple_result.dart';

import '../models/hospital/hospital_model.dart';

abstract class HospitalRepo {
  Future<Result<HospitalModel, dynamic>> getHospital({required String uuid});

  Future<Result<List<HospitalModel>, dynamic>> getHospitales();

  Future<Result<dynamic, dynamic>> addHospital({
    required String hospital,
  });

  Future<Result<dynamic, dynamic>> updateHospital({
    required String uuid,
    required String hospital,
  });

  Future<Result<dynamic, dynamic>> deleteHospital({required String uuid});
}
