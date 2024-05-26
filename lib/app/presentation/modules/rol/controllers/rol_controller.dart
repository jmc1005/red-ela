import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/rol/rol_model.dart';
import '../../../../domain/repository/rol_repo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';

class RolController extends StateNotifier<RolModel?> {
  RolController({
    required this.context,
    required this.rolRepo,
  }) : super(null);

  final BuildContext context;
  final RolRepo rolRepo;

  set rol(RolModel? rolModel) {
    rolModel ??= const RolModel(
      uuid: '',
      rol: '',
      descripcion: '',
    );
    onlyUpdate(rolModel);
  }

  void onChangeRol(String text) {
    rol = state!.copyWith(rol: text);
  }

  void onChangeDescripcion(String text) {
    rol = state!.copyWith(descripcion: text);
  }

  Future<void> update(AppLocalizations language) async {
    Result<dynamic, dynamic> response;
    if (state!.uuid != '') {
      response = await rolRepo.updateRol(
        uuid: state!.uuid,
        rol: state!.rol,
        descripcion: state!.descripcion,
      );
    } else {
      response = await rolRepo.addRol(
        rol: state!.rol,
        descripcion: state!.descripcion,
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

    showResponseResult(code, isSuccess, language);
  }

  void showWarning(AppLocalizations language) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: FirebaseCode.reviewFormData,
    );

    response.showWarning();
  }

  void showResponseResult(String code, bool isSuccess, language) {
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
