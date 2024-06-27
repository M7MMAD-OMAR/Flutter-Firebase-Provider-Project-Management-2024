import 'VarTopModel.dart';

//description,start time,end time

//task model class,projects model class
abstract class Var2TopModel extends VarTopModel {
  @override
  set setCreatedAt(DateTime createdAt);
  @override
  set setId(String id);
  @override
  set setName(String name);
  @override
  set setUpdatedAt(DateTime updatedAt);

  late DateTime startDate;
  set setStartDate(DateTime? startDate);
  DateTime get getStartDate => startDate;

  DateTime? endDate;
  set setEndDate(DateTime? endDate);
  get getendDate => endDate;

  late String statusId;
  set setStatusId(String statusId);
  get getstatusId => statusId;

  late String? description;
  set setDescription(String description);
  get getdescription => description;

  Duration differeInTime(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    return diff;
  }
}
