mixin TopModel {
  late String id;

  set setId(String id);

  /*ملاحظة هامة الميكسين مابتساويلك get افتراضية من عندها لهيك منعمل وحدة نحنا
  بينما الكلاس ابستركت هو بيساويها افتراضية بولادو وبيطلع الحقلل تلقائي عند الولاد
  */

  late DateTime createdAt;

  set setCreatedAt(DateTime createdAt);

  //DateTime get getCreatedAt => createdAt;
  late DateTime updatedAt;

  set setUpdatedAt(DateTime updatedAt);

  // DateTime get getUpdatedAt => updatedAt;
  Map<String, dynamic> toFirestore();
}
