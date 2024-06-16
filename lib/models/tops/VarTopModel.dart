import 'package:project_management_muhmad_omar/models/tops/top_model.dart';

abstract class VarTopModel with TopModel {
  String? name;

  set setName(String name);

  @override
  set setCreatedAt(DateTime createdAt);

  @override
  set setUpdatedAt(DateTime updatedAt);

  @override
  set setId(String id);
}
