import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/tratamiento/tratamiento_model.dart';
import '../../../../domain/repository/tratamiento_repo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';

class TratamientoController extends StateNotifier<TratamientoModel?> {
  TratamientoController({
    required this.tratamientoRepo,
  }) : super(null);

  final TratamientoRepo tratamientoRepo;

  set tratamiento(TratamientoModel tratamientoModel) {
    onlyUpdate(tratamientoModel);
  }

  void onChangeTratamiento(String text) {
    tratamiento = state!.copyWith(tratamiento: text);
  }

  Future<void> update(context, language) async {
    Result<dynamic, dynamic> response;
    if (state!.uuid != '') {
      response = await tratamientoRepo.updateTratamiento(
        uuid: state!.uuid,
        tratamiento: state!.tratamiento,
      );
    } else {
      response = await tratamientoRepo.addTratamiento(
        tratamiento: state!.tratamiento,
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
