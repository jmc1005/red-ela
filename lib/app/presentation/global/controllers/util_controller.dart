import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_constants.dart';

class UtilController {
  UtilController({required this.onChange});

  final Function(String) onChange;

  Future<void> openDatePicker(
    BuildContext context,
    TextEditingController dateInput,
  ) async {
    final language = AppLocalizations.of(context)!;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: Locale(language.localeName),
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String date = DateFormat(
        AppConstants.formatDate,
      ).format(
        pickedDate,
      );

      onChange(date);
      dateInput.text = date;
    } else {}
  }

  Future<void> openTimePicker(
    BuildContext context,
    TextEditingController timeInput,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, childWidget) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: childWidget!);
      },
    );

    if (pickedTime != null) {
      var hour = pickedTime.format(context);

      if (hour.contains('AM') || hour.contains('PM')) {
        final DateFormat format12 = DateFormat.jm();
        final DateTime dateTime = format12.parse(hour);
        final DateFormat format24 = DateFormat.Hm();
        hour = format24.format(dateTime);
      }

      onChange(hour);
      timeInput.text = hour;
    } else {}
  }
}
