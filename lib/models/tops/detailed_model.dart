import 'basic_model.dart';

abstract class DetailedModel extends BasicModel {
  late DateTime startDate;
  DateTime? endDate;
  late String statusId;
  String? description;

  set setStartDate(DateTime startDate);

  DateTime get getStartDate => startDate;

  set setEndDate(DateTime? endDate);

  DateTime? get getEndDate => endDate;

  set setStatusId(String statusId);

  String get getStatusId => statusId;

  set setDescription(String description);

  String? get getDescription => description;

  Duration differenceInTime(DateTime start, DateTime end) {
    return end.difference(start);
  }
}
