import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static const _fileName = 'assets/dotenv';

  static Future init() async {
    await dotenv.load(fileName: _fileName);
  }
}
