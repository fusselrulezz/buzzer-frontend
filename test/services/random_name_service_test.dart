import 'package:flutter_test/flutter_test.dart';
import 'package:buzzer/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RandomNameServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
