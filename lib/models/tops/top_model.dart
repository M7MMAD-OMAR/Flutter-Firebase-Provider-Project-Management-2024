mixin TopModel {
  late String id;

  set setId(String id);

  late DateTime createdAt;

  set setCreatedAt(DateTime createdAt);

  late DateTime updatedAt;

  set setUpdatedAt(DateTime updatedAt);

  Map<String, dynamic> toFirestore();
}
