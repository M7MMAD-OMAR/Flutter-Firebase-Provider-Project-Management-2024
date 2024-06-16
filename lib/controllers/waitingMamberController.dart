import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';

import '../constants/back_constants.dart';
import '../models/team/teamModel.dart';
import '../models/team/team_members_model.dart';
import '../models/user/user_model.dart';
import '../services/auth_service.dart';
import '../services/notifications/notification_service.dart';

class WaitingMamberController extends TopController {
  //جبلي هل الشخص يلي لسع مو قبلان دعوة الانضمام
  Future<WaitingMemberModel> getWaitingMemberById(
      {required String watingmemberId}) async {
    DocumentSnapshot doc =
        await getDocById(reference: watingMamberRef, id: watingmemberId);
    return doc.data() as WaitingMemberModel;
  }

//عرض جميع الأشخاص يلي بعتلن دعوة للانضمام لهل الفريق وماقبلوها لسع
  Future<List<WaitingMemberModel>> getWaitingMembersInTeamId(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingMamberRef, field: teamIdK, value: teamId);
    List<WaitingMemberModel> listOfMembers = list!.cast<WaitingMemberModel>();
    return listOfMembers;
  }

//عرض  الشخص يلي بعتلو دعوة للانضمام لهل الفريق وماقبلهاا لسع
  Future<WaitingMemberModel> getWaitingMemberByTeamIdAndUserId(
      {required String teamId, required String userId}) async {
    DocumentSnapshot doc = await getDocSnapShotWhereAndWhere(
        collectionReference: watingMamberRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return doc.data() as WaitingMemberModel;
  }

//عرض  الشخص يلي بعتلو دعوة للانضمام لهل الفريق وماقبلهاا لسع
  Stream<DocumentSnapshot<WaitingMemberModel>>
      getWaitingMemberByTeamIdAndUserIdStream(
          {required String teamId, required String userId}) {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: watingMamberRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return stream.cast<DocumentSnapshot<WaitingMemberModel>>();
  }

  Stream<QuerySnapshot<WaitingMemberModel>> getWaitingMembersInUserIdStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: watingMamberRef, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<WaitingMemberModel>>();
  }

//عرض جميع الأشخاص يلي بعتلن دعوة للانضمام لهل الفريق وماقبلوها لسع
  Stream<QuerySnapshot<WaitingMemberModel>> getWaitingMembersInTeamIdStream(
      {required String teamId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: watingMamberRef, field: teamIdK, value: teamId);
    return stream.cast<QuerySnapshot<WaitingMemberModel>>();
  }

  Future<DocumentSnapshot> getWaitingMemberDoc(
      {required String waitingmemberId}) async {
    return await getDocById(reference: watingMamberRef, id: waitingmemberId);
  }

  Future<void> addWaitingMamber(
      {required WaitingMemberModel waitingMemberModel}) async {
    if (await existInTowPlaces(
        firstCollectionReference: usersRef,
        firstFiled: idK,
        firstvalue: waitingMemberModel.userId,
        secondCollectionReference: teamsRef,
        secondFiled: idK,
        secondValue: waitingMemberModel.teamId)) {
      if (waitingMemberModel.userId ==
          AuthService.instance.firebaseAuth.currentUser!.uid) {
        throw Exception(AppConstants.manager_cannot_be_member_error_key.tr);
      }
      if (await existByTow(
          reference: watingMamberRef,
          value: waitingMemberModel.userId,
          field: userIdK,
          value2: waitingMemberModel.teamId,
          field2: teamIdK)) {
        throw Exception(AppConstants.member_already_invited_key.tr);
      }
      addDoc(reference: watingMamberRef, model: waitingMemberModel);
    } else {
      throw Exception(AppConstants.team_user_not_found_error_key.tr);
    }
  }

  Future<void> acceptTeamInvite({required String waitingMemberId}) async {
    await teamInviteHandler(
        waitingMemberId: waitingMemberId, isAccepted: true, memberMessage: '');
  }

  Future<void> declineTeamInvite({
    required String waitingMemberId,
    required String rejectingMessage,
  }) async {
    String reasonforRejection = "${AppConstants.rejection_reason_key.tr} $rejectingMessage";
    await teamInviteHandler(
      waitingMemberId: waitingMemberId,
      isAccepted: false,
      memberMessage: reasonforRejection,
    );
  }

  Future<void> teamInviteHandler({
    required String waitingMemberId,
    required bool isAccepted,
    required String memberMessage,
  }) async {
   String status = isAccepted
        ? AppConstants.accepted_key.tr
        : AppConstants.rejected_key.tr;
    //user Controller to send the notification to the manager about whether the user acepted the invite or not
    UserController userController = Get.put(UserController());
    //to get the team model so we get the manager model and then get the manager user profile to sned the notification
    TeamController teamController = Get.put(TeamController());

    WaitingMemberModel waitingMember =
        await getWaitingMemberById(watingmemberId: waitingMemberId);

    deleteWaitingMamberDoc(waitingMemberId: waitingMemberId);

    if (isAccepted) {
      //to add the invited member to the team
      TeamMemberController teamMemberController =
          Get.put(TeamMemberController());

      TeamMemberModel teamMemberModel = TeamMemberModel(
        idParameter: teamMembersRef.doc().id,
        userIdParameter: waitingMember.userId,
        teamIdParameter: waitingMember.teamId,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now(),
      );
      await teamMemberController.addMember(teamMemberModel: teamMemberModel);
    }

    TeamModel teamModel =
        await teamController.getTeamById(id: waitingMember.teamId);

    UserModel manager = await userController.getUserWhereMangerIs(
        mangerId: teamModel.managerId);

    //to get the user name to tell the manager about his name in the notification
    UserModel member = await userController.getUserById(
        id: AuthService.instance.firebaseAuth.currentUser!.uid);

    FcmNotifications fcmNotifications = Get.put(FcmNotifications());
    await fcmNotifications.sendNotification(
        fcmTokens: manager.tokenFcm,
        title: "${AppConstants.invite_got_key.tr} $status",
        body:
            "${member.name} $status ${AppConstants.invite_to_team_key.tr} ${teamModel.name} $memberMessage",
        type: NotificationType.notification);
  }

//حذفو بعد الرفض او القبول والانضمام
  Future<void> deleteWaitingMamberDoc({required String waitingMemberId}) async {
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(
        documentSnapshot: await watingMamberRef.doc(waitingMemberId).get(),
        refbatch: batch);
    batch.commit();
  }
}
