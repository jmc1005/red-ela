import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/hospital/hospital_model.dart';
import '../../../../domain/repository/hospital_repo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';

class HospitalController extends StateNotifier<HospitalModel?> {
  HospitalController({
    required this.hospitalRepo,
  }) : super(null);

  final HospitalRepo hospitalRepo;

  set hospital(HospitalModel hospitalModel) {
    onlyUpdate(hospitalModel);
  }

  void onChangeHospital(String text) {
    hospital = state!.copyWith(hospital: text);
  }

  Future<void> update(context, language) async {
    Result<dynamic, dynamic> response;
    if (state!.uuid != '') {
      response = await hospitalRepo.updateHospital(
        uuid: state!.uuid,
        hospital: state!.hospital,
      );
    } else {
      response = await hospitalRepo.addHospital(
        hospital: state!.hospital,
      );
    }

    late String code;
    late bool isSuccess = true;

    response.when((success) {
      code = success;
    }, (error) {
      code = error;
      isSuccess = false;
    });

    showResponseResult(context, code, isSuccess, language);
  }

  void showWarning(context, language) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: FirebaseCode.reviewFormData,
    );

    response.showWarning();
  }

  void showResponseResult(context, code, isSuccess, language) {
    final fbResponse = FirebaseResponse(
      context: context,
      language: language,
      code: code,
    );

    if (isSuccess) {
      fbResponse.showSuccess();
    } else {
      fbResponse.showError();
    }
  }
}
