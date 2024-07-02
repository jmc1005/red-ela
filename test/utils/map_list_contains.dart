import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_ela/app/domain/models/typedefs.dart';

class MapListContains extends Matcher {
  final String? key;
  final Json _expected;

  MapListContains(this.key, this._expected);

  @override
  Description describe(Description description) {
    return description.add('contains ').addDescriptionOf(_expected);
  }

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is List<Map>) {
      if (key != null) {
        return item.any((element) => mapEquals(element[key], _expected[key]));
      }

      return item.any((element) => mapEquals(element, _expected));
    }
    return false;
  }
}
