import '../tops/var2_top_model.dart';

abstract class TaskClass extends Var2TopModel {
  late int importance;

  set setImportance(int importance);

  late String hexColor;

  set setHexColor(String color);

  @override
  set setId(String id);

  @override
  set setName(String name);

  @override
  set setCreatedAt(DateTime createdAt);

  @override
  set setUpdatedAt(DateTime updatedAt);

  @override
  set setDescription(String description);

  @override
  set setStatusId(String statusId);

  @override
  set setStartDate(DateTime? startDate);

  @override
  set setEndDate(DateTime? endDate);
}
