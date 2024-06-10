mixin TopModel {
  late String id;
  late DateTime createdAt;
  late DateTime updatedAt;

  set setId(String id);

  set setCreatedAt(DateTime createdAt);

  set setUpdatedAt(DateTime updatedAt);

  Map<String, dynamic> toFirestore();
}
