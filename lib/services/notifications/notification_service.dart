import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_controller.dart';
import 'package:project_management_muhmad_omar/controllers/statusController.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_controller.dart';
import 'package:project_management_muhmad_omar/controllers/waitingMamberController.dart';
import 'package:project_management_muhmad_omar/controllers/waitingSubTasks.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_controller_services.dart';

class FcmNotificationsProvider {
  static const String key = 'notification_status';

  static Future<bool> getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  static Future<void> setNotificationStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, status);
  }

  @pragma('vm:entry-point')
  Future<void> sendNotification({
    required List<String> fcmTokens,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, String>? data,
  }) async {
    Map<String, String> insidedata = <String, String>{};
    insidedata.addAll({
      'type': type.name,
    });
    if (data != null) {
      insidedata.addAll(data);
    }
    await NotificationController.sendPushMessage(
      fcmTokens: fcmTokens,
      title: title,
      body: body,
      data: insidedata,
    );
  }

  @pragma('vm:entry-point')
  Future<void> sendNotificationAsJson({
    required List<String> fcmTokens,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, String>? data,
  }) async {
    Map<String, dynamic> dataJson = initializeJson(
      type: type,
      body: body,
      data: data,
      title: title,
    );
    await NotificationController.sendPushMessageJson(
        data: dataJson, fcmTokens: fcmTokens);
  }

  static Map<String, dynamic> initializeJson({
    Map<String, String>? data,
    required String title,
    required String body,
    required NotificationType type,
  }) {
    Map<String, dynamic> insidedata = <String, dynamic>{};
    NotificationContent content =
        getContent(title: title, body: body, type: type, data: data);
    List<Map<String, dynamic>> button =
        FcmNotificationsProvider.getButtonsByNotificationType(type: type);
    insidedata.addAll({
      "notification": {
        "content": content.toMap(),
        "actionButtons": button,
      }
    });
    return insidedata;
  }

  static NotificationContent getContent({
    Map<String, String>? data,
    required String title,
    required String body,
    required NotificationType type,
  }) {
    Random random = Random();
    NotificationContent content = NotificationContent(
      id: random.nextInt(999),
      channelKey: getChannelByType(notificationType: type),
      title: title,
      body: body,
      criticalAlert: true,
      wakeUpScreen: true,
      payload: data,
      displayOnForeground: true,
      displayOnBackground: true,
    );

    return content;
  }

  static String getChannelByType({required NotificationType notificationType}) {
    String channel = "high_importance_channel";
    switch (notificationType) {
      case NotificationType.notification:
        break;
      case NotificationType.memberTaskTimeFinished:
        break;
      case NotificationType.userTaskTimeFinished:
        break;
      case NotificationType.taskRecieved:
        break;
      case NotificationType.teamInvite:
        break;
      default:
    }
    return channel;
  }

  static String getSoundByType({required NotificationType notificationType}) {
    String sound = "task_completed";
    switch (notificationType) {
      case NotificationType.notification:
        sound = "pikachu";
        break;
      case NotificationType.memberTaskTimeFinished:
        break;
      case NotificationType.userTaskTimeFinished:
        break;
      case NotificationType.taskRecieved:
        break;
      case NotificationType.teamInvite:
        break;
      default:
    }
    return sound;
  }

  @pragma('vm:entry-point')
  Future<void> fcmHandler() async {
    FirebaseMessaging.onMessage.listen(handleMessageJson);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageJson);
    FirebaseMessaging.onBackgroundMessage(handleMessageJson);
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      handleMessageJson(remoteMessage);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> handleMessage(RemoteMessage message) async {
    FcmNotificationsProvider notifications =
        Get.put(FcmNotificationsProvider());

    Map<String, String> datapayload =
        Map<String, String>.from(message.data.cast<String, String>());

    List<NotificationActionButton>? buttons;

    NotificationType type =
        NotificationType.values.byName(datapayload["type"]!);

    await notifications.showNotification(
      title: message.data["title"]!,
      body: message.data["body"]!!,
      payload: datapayload,
      buttons: buttons,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> handleMessageJson(RemoteMessage message) async {
    if (await getNotificationStatus() == true) {
      Map<String, dynamic> s = jsonDecode(message.data["data"]);

      await NotificationController.showNotificationJson(s["notification"]);
    }
  }

  @pragma('vm:entry-point')
  static List<Map<String, dynamic>> getButtonsByNotificationType(
      {required NotificationType type}) {
    List<NotificationActionButton> buttons = [];

    switch (type) {
      case NotificationType.teamInvite:
        buttons.addAll([
          NotificationActionButton(
            key: NotificationButtonskeys.acceptTeamInvite.name,
            label: 'accept',
            actionType: ActionType.KeepOnTop,
          ),
          NotificationActionButton(
            key: NotificationButtonskeys.declineTeamInvite.name,
            label: 'decline Invite',
            actionType: ActionType.KeepOnTop,
            requireInputText: true,
          )
        ]);

        break;
      case NotificationType.taskRecieved:
        buttons.addAll([
          NotificationActionButton(
            key: NotificationButtonskeys.acceptTask.name,
            label: 'accept',
            actionType: ActionType.KeepOnTop,
          ),
          NotificationActionButton(
            key: NotificationButtonskeys.declineTask.name,
            label: 'decline',
            actionType: ActionType.KeepOnTop,
            requireInputText: true,
          )
        ]);
        break;
      case NotificationType.userTaskTimeFinished:
        buttons.addAll([
          NotificationActionButton(
            key: NotificationButtonskeys.markUserTaskDone.name,
            label: 'done',
            actionType: ActionType.KeepOnTop,
          ),
          NotificationActionButton(
            key: NotificationButtonskeys.markUserTaskNotDone.name,
            label: 'not done',
            actionType: ActionType.KeepOnTop,
          )
        ]);
        break;
      case NotificationType.memberTaskTimeFinished:
        buttons.addAll([
          NotificationActionButton(
            key: NotificationButtonskeys.markSubTaskDone.name,
            label: 'تم',
            actionType: ActionType.KeepOnTop,
          ),
          NotificationActionButton(
            key: NotificationButtonskeys.markSubTaskNotDone.name,
            label: 'غير مكتمل',
            actionType: ActionType.KeepOnTop,
            requireInputText: true,
          )
        ]);
        break;
      default:
    }

    buttons.add(
      NotificationActionButton(
        key: NotificationButtonskeys.markAsRead.name,
        label: NotificationButtonskeys.markAsRead.name,
        requireInputText: false,
        actionType: ActionType.DisabledAction,
      ),
    );
    List<Map<String, dynamic>> buttonMap = [];
    for (NotificationActionButton element in buttons) {
      buttonMap.add(element.toMap());
    }
    return buttonMap;
  }

  @pragma('vm:entry-point')
  Future<void> showNotification({
    required String title,
    required String body,
    required Map<String, String> payload,
    List<NotificationActionButton>? buttons,
  }) async {
    await NotificationController.showNotification(
      title: title,
      body: body,
      actionButtons: buttons,
      payload: payload,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    UserTaskController userTaskController = Get.put(UserTaskController());
    StatusController statusController = Get.put(StatusController());
    NotificationButtonskeys type =
        NotificationButtonskeys.values.byName(receivedAction.buttonKeyPressed);
    switch (type) {
      case NotificationButtonskeys.markUserTaskDone:
        String taskId = receivedAction.payload!["id"]!;

        StatusModel statusModel =
            await statusController.getStatusByName(status: statusDone);
        userTaskController.updateUserTask(
            isfromback: true, data: {statusIdK: statusModel.id}, id: taskId);
        break;

      case NotificationButtonskeys.markUserTaskNotDone:
        String taskId = receivedAction.payload!["id"]!;
        StatusModel s =
            await statusController.getStatusByName(status: statusNotDone);
        userTaskController.updateUserTask(
            isfromback: true, data: {statusIdK: s.id}, id: taskId);
        break;

      case NotificationButtonskeys.acceptTeamInvite:
        String waitingMemberId = receivedAction.payload!["id"]!;
        WaitingMamberController waitingMamberController =
            Get.put(WaitingMamberController());
        await waitingMamberController.acceptTeamInvite(
            waitingMemberId: waitingMemberId);
        break;

      case NotificationButtonskeys.declineTeamInvite:
        String waitingMemberId = receivedAction.payload!["id"]!;
        WaitingMamberController waitingMamberController =
            Get.put(WaitingMamberController());
        String rejectingMessage = receivedAction.buttonKeyInput;

        await waitingMamberController.declineTeamInvite(
          waitingMemberId: waitingMemberId,
          rejectingMessage: rejectingMessage,
        );
        break;
      case NotificationButtonskeys.acceptTask:
        String waitingSubTaskId = receivedAction.payload!["id"]!;
        WatingSubTasksController watingSubTasksController =
            Get.put(WatingSubTasksController());
        await watingSubTasksController.accpetSubTask(
          waitingSubTaskId: waitingSubTaskId,
        );
        break;

      case NotificationButtonskeys.declineTask:
        String waitingSubTaskId = receivedAction.payload!["id"]!;
        WatingSubTasksController watingSubTasksController =
            Get.put(WatingSubTasksController());
        String rejectingMessage = receivedAction.buttonKeyInput;
        await watingSubTasksController.rejectSubTask(
            waitingSubTaskId: waitingSubTaskId,
            rejectingMessage: rejectingMessage);
        break;

      case NotificationButtonskeys.markSubTaskDone:
        String subtaskId = receivedAction.payload!["id"]!;

        ProjectSubTaskController projectSubTaskController =
            Get.put(ProjectSubTaskController());
        projectSubTaskController.markSubTaskeAndSendNotification(
            subtaskId, statusDone);
        break;
      case NotificationButtonskeys.markSubTaskNotDone:
        String subtaskId = receivedAction.payload!["id"]!;

        ProjectSubTaskController projectSubTaskController =
            Get.put(ProjectSubTaskController());
        projectSubTaskController.markSubTaskeAndSendNotification(
            subtaskId, statusNotDone);
        break;
      default:
    }
  }
}
