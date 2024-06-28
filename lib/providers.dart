import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
    // End Project Provider
  ].toList();
}
