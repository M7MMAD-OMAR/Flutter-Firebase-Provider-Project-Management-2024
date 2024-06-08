import 'package:provider/provider.dart';

import 'providers/test/test_provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<TestProvider>(
      create: (_) => TestProvider(),
    ),
  ].toList();
}
