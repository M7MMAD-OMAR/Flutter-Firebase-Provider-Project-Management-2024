import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_management_muhmad_omar/providers/team_provider.dart';
import 'package:project_management_muhmad_omar/providers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/providers/top_provider.dart';
import 'package:project_management_muhmad_omar/providers/user_provider.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';
import 'package:provider/provider.dart';

import '../constants/back_constants.dart';
import '../constants/constants.dart';
import '../models/team/teamModel.dart';
import '../models/team/team_members_model.dart';
import '../models/user/user_model.dart';
import 'auth_provider.dart';
import '../services/notifications/notification_service.dart';

class WaitingMemberProvider extends TopProvider {
  Future<WaitingMemberModel> getWaitingMemberById(
      {required String watingMemberId}) async {
    DocumentSnapshot doc =
        await getDocById(reference: watingMamberRef, id: watingMemberId);
    return doc.data() as WaitingMemberModel;
  }

  Future<List<WaitingMemberModel>> getWaitingMembersInTeamId(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingMamberRef, field: teamIdK, value: teamId);
    List<WaitingMemberModel> listOfMembers = list!.cast<WaitingMemberModel>();
    return listOfMembers;
  }

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
          AuthProvider.firebaseAuth.currentUser!.uid) {
        throw Exception('لا يمكن أن يكون المدير عضوا');
      }
      if (await existByTow(
          reference: watingMamberRef,
          value: waitingMemberModel.userId,
          field: userIdK,
          value2: waitingMemberModel.teamId,
          field2: teamIdK)) {
        throw Exception('العضو تمت دعوته مسبقًا إلى الفريق');
      }
      addDoc(reference: watingMamberRef, model: waitingMemberModel);
    } else {
      throw Exception(
          'عذرًا، ولكن لم يتم العثور على الفريق أو المستخدم الخاص بهذا العضو');
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
    String reasonforRejection = "سبب الرفض $rejectingMessage";
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
    String status = isAccepted ? 'قبولها' : 'رفضها';
    BuildContext context = navigatorKey.currentContext!;

    UserProvider userController = Provider.of<UserProvider>(context);

    TeamProvider teamController = Provider.of<TeamProvider>(context);

    WaitingMemberModel waitingMember =
        await getWaitingMemberById(watingMemberId: waitingMemberId);

    deleteWaitingMamberDoc(waitingMemberId: waitingMemberId);

    if (isAccepted) {
      final TeamMemberProvider teamMemberController =
          Provider.of<TeamMemberProvider>(context);

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

    UserModel member = await userController.getUserById(
        id: AuthProvider.firebaseAuth.currentUser!.uid);
    FcmNotificationsProvider fcmNotifications =
        Provider.of<FcmNotificationsProvider>(context);
    await fcmNotifications.sendNotification(
        fcmTokens: manager.tokenFcm,
        title: " الدعوة تم $status",
        body:
            "${member.name} $status دعوتك للانضمام إلى الفريق ${teamModel.name} $memberMessage",
        type: NotificationType.notification);
  }

  Future<void> deleteWaitingMamberDoc({required String waitingMemberId}) async {
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(
        documentSnapshot: await watingMamberRef.doc(waitingMemberId).get(),
        refbatch: batch);
    batch.commit();
  }
}
