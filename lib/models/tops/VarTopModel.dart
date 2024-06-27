import 'TopModel_model.dart';

//the classes that inherit from this class directly
//User class/task category class/teams class/status class

//name,created at,updated at
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
