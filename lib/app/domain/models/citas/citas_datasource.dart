import 'package:syncfusion_flutter_calendar/calendar.dart';

class CitaDataSource extends CalendarDataSource {
  CitaDataSource(List<Appointment> source) {
    appointments = source;
  }
}
