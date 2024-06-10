import 'top_model.dart';

abstract class BasicModel with TopModel {
  String? name;

  set setName(String name);

  @override
  set setCreatedAt(DateTime createdAt);

  @override
  set setUpdatedAt(DateTime updatedAt);

  @override
  set setId(String id);
}
