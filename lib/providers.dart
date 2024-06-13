import 'package:project_management_muhmad_omar/providers/my_auth_provider.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<MyAuthProvider>(
      create: (_) => MyAuthProvider(),
    ),
  ].toList();
}
