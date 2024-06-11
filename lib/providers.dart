import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'providers/test/test_provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<TestProvider>(
      create: (_) => TestProvider(),
    ),
    Provider<AuthService>(
      create: (_) => AuthService(),
    ),
  ].toList();
}
