import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/task/user_task_category_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_task_Model.dart';

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
//الكولكشن الخاصة بمهام المستخدمين
final CollectionReference usersTasksRef =
    fireStore.collection("users_tasks").withConverter<UserTaskModel>(
          fromFirestore: (snapshot, options) =>
              UserTaskModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالحالة (المشروع أو المهام الفردية او الخاصة بالفرق)
final CollectionReference statusesRef =
    fireStore.collection("statuses").withConverter<StatusModel>(
          fromFirestore: (snapshot, options) =>
              StatusModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

//الكولكشن الخاصة بالمدراء الذين هم المستخدمون الذين يمتلكون فرق في التطبيق
final CollectionReference managersRef =
    fireStore.collection("managers").withConverter<ManagerModel>(
          fromFirestore: (snapshot, options) =>
              ManagerModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بأعضاء الفرق
final CollectionReference teamMembersRef =
    fireStore.collection("team_members").withConverter<TeamMemberModel>(
          fromFirestore: (snapshot, options) =>
              TeamMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//
final CollectionReference watingMamberRef =
    fireStore.collection("waiting_members").withConverter<WaitingMemberModel>(
          fromFirestore: (snapshot, options) =>
              WaitingMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالفرق الموجودة في التطبيق تحتوي على المدير واي دي يمكننا من الوصول إلى أعضاء الفريق من خلال
//الكولكشن الخاصة بال تيم ميمبرز
final CollectionReference teamsRef =
    fireStore.collection("teams").withConverter<TeamModel>(
          fromFirestore: (snapshot, options) =>
              TeamModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالمشاريع يمكن معرفة الفريق الذي يستلم المشروع من خلال الاي دي والوصول له في الكولكشن الخاص به
final CollectionReference projectsRef =
    fireStore.collection("projects").withConverter<ProjectModel>(
          fromFirestore: (snapshot, options) =>
              ProjectModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالمهام الرئيسية في المشروع الخاص بالفريق بحيث يمكن يندرج تحت المهمة الأساسية مهام فرعية
//وبذلك يمكننا تقسيم مهمة مثل تطوير الفرونت إلى أكثر من عضو في الفريق
//هي الميزة مو عند حدا ترا غيرنا انضم لنا وكن جزءاُ من فريق كل يومين بيتخانقو
final CollectionReference projectMainTasksRef = FirebaseFirestore.instance
    .collection("project_main_tasks")
    .withConverter<ProjectMainTaskModel>(
      fromFirestore: (snapshot, options) =>
          ProjectMainTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
//الكولكشن الخاصة بالمهام الفرعية في المشروع التي يتم إسنادها إلى أعضاء الفريق
//يمكن الوصول إلى العضو المراد إسناد المهمة إليه من خلال الكولكشن الخاصة بالأعضاء
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
