import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/models/tops/basic_model.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

class StatusModel extends BasicModel {
  StatusModel({
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String idParameter,
  }) {
    setCreatedAt = createdAt;
    setName = name;
    setUpdatedAt = updatedAt;
    setId = idParameter;
  }

  StatusModel.firestoreConstructor({
    required String nameParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required String id,
  }) {
    createdAt = createdAtParameter;
    name = nameParameter;
    updatedAt = updatedAtParameter;
    this.id = id;
  }

  @override
  set setCreatedAt(DateTime? createdAtParameter) {
    Exception exception;

    if (createdAtParameter == null) {
      throw Exception("created Time Can not be null ");
    }
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      throw Exception("status creating time cannot be in the future");
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception("status creating time cannot be in the past");
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    print("${idParameter}id parameter");
    Exception exception;

    if (idParameter.isEmpty) {
      throw Exception("status id cannot be empty");
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      throw Exception("status Name cannot be Empty");
    }
    if (nameParameter.length <= 3) {
      throw Exception("status Name cannot be less than 3 characters");
    }

    name = nameParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("status creating Time Can not be last time before now ");
    }
    updatedAt = updatedAtParameter;
  }

  factory StatusModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return StatusModel.firestoreConstructor(
      nameParameter: data['name'],
      id: data['id'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return "status name is $name id:$id  createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
