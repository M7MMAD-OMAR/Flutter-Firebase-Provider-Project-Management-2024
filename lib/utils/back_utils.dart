import 'package:firebase_storage/firebase_storage.dart';

DateTime firebaseTime(DateTime dateTime) {
  DateTime newDate = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    0,
  );
  return newDate;
}

final firebaseStorage = FirebaseStorage.instance;

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
