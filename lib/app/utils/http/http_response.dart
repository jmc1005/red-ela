import 'dart:io';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HttpResponse {
  final AppLocalizations language;
  final BuildContext context;
  final int statusCode;

  HttpResponse({
    required this.context,
    required this.language,
    required this.statusCode,
  });

  String get error {
    switch (statusCode) {
      case HttpStatus.badRequest:
        return 'Error $statusCode ${language.badRequest}';
      case HttpStatus.unauthorized:
        return 'Error $statusCode ${language.unauthorized}';
      case HttpStatus.forbidden:
        return 'Error $statusCode ${language.forbidden}';
      case HttpStatus.notFound:
        return 'Error $statusCode ${language.notFound}';
      case HttpStatus.requestTimeout:
        return 'Error $statusCode ${language.requestTimeout}';
      case HttpStatus.internalServerError:
        return 'Error $statusCode ${language.internalServerError}';
      case HttpStatus.serviceUnavailable:
        return 'Error $statusCode ${language.serviceUnavailable}';
    }

    return 'Error $statusCode ${language.unknown}';
  }

  void showError() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: error),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.endToStart],
    );
  }
}
