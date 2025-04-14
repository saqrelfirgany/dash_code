import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDownAll(() {});

  await testMain();
}
