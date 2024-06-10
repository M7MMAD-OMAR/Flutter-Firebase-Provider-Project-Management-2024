import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';

import '../tops/top_model.dart';

class WaitingSubTaskModel with TopModel {
  WaitingSubTaskModel({
    required createdAt,
    required updatedAt,
    required id,
    this.reasonOfRefuse,
    required this.projectSubTaskModel,
  }) {
    setId = id;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
  }

  String? reasonOfRefuse;
  late ProjectSubTaskModel projectSubTaskModel;

  @override
  set setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  @override
  set setId(String id) {
    this.id = id;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory WaitingSubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return WaitingSubTaskModel(
      projectSubTaskModel: ProjectSubTaskModel.fromJson(data['subTask']),
      id: data['id'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTask'] = projectSubTaskModel.toFirestore();
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
