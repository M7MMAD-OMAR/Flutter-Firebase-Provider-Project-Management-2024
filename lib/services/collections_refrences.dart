import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/models/User/user_model.dart';
import 'package:project_management_muhmad_omar/models/User/user_task_model.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_mamber.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference<UserModel> usersRef =
    fireStore.collection("users").withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromFireStore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference userTaskCategoryRef = fireStore
    .collection("users_tasks_categories")
    .withConverter<UserTaskCategoryModel>(
      fromFirestore: (snapshot, options) =>
          UserTaskCategoryModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );

final CollectionReference usersTasksRef =
    fireStore.collection("users_tasks").withConverter<UserTaskModel>(
          fromFirestore: (snapshot, options) =>
              UserTaskModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference statusesRef =
    fireStore.collection("statuses").withConverter<StatusModel>(
          fromFirestore: (snapshot, options) =>
              StatusModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference managersRef =
    fireStore.collection("managers").withConverter<ManagerModel>(
          fromFirestore: (snapshot, options) =>
              ManagerModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference teamMembersRef =
    fireStore.collection("team_members").withConverter<TeamMemberModel>(
          fromFirestore: (snapshot, options) =>
              TeamMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference watingMamberRef =
    fireStore.collection("waiting_members").withConverter<WaitingMemberModel>(
          fromFirestore: (snapshot, options) =>
              WaitingMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference teamsRef =
    fireStore.collection("teams").withConverter<TeamModel>(
          fromFirestore: (snapshot, options) =>
              TeamModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference projectsRef =
    fireStore.collection("projects").withConverter<ProjectModel>(
          fromFirestore: (snapshot, options) =>
              ProjectModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

final CollectionReference projectMainTasksRef = FirebaseFirestore.instance
    .collection("project_main_tasks")
    .withConverter<ProjectMainTaskModel>(
      fromFirestore: (snapshot, options) =>
          ProjectMainTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );

final CollectionReference projectSubTasksRef = fireStore
    .collection("project_sub_tasks")
    .withConverter<ProjectSubTaskModel>(
      fromFirestore: (snapshot, options) =>
          ProjectSubTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
final CollectionReference watingSubTasksRef = fireStore
    .collection("waiting_sub_tasks")
    .withConverter<WaitingSubTaskModel>(
      fromFirestore: (snapshot, options) =>
          WaitingSubTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
