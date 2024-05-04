// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

List<String> notiIds = [];
bool isSoundOn = true;

class NotificationMethods {
  //notiification
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  clearAllNotification() async {
    print('CLEAR ALL NOTIFICATION CLICK');
    await flutterLocalNotificationsPlugin.cancelAll();
    print('CLEAR ALL NOTIFICATION SUCCESS');
  }

  ///OTHER NOTIFICATION SYSTEM DEFAULT SOUND
  static AndroidNotificationDetails androidPlatformChannelSpecifics() =>
      AndroidNotificationDetails(
        'edupulse',
        'Notifications',
        // 'Notifications',
        color: Color(0xff67C117),
        playSound: isSoundOn,
        importance: Importance.high,
        priority: Priority.max,
        icon: '@mipmap/ic_launcher',
      );

  /// NEW ORDER NOTIFICATION CUSTOM SOUND
  // static AndroidNotificationDetails androidPlatformChannelSpecificsForNewOrder(
  //     {String? sound}) {
  //   print('SOU........:$sound');
  //   return AndroidNotificationDetails(
  //     'ClubGrubRestaurant',
  //     'Order Notifications',
  //     'All Order Status Notifications',
  //     color: Color(0xff67C117),
  //     playSound: true,
  //     importance: Importance.high,
  //     priority: Priority.max,
  //     icon: '@drawable/ic_launcher',
  //     // sound: RawResourceAndroidNotificationSound(
  //     //     sound == 'default' ? 'default_notification' : sound),
  //     sound: RawResourceAndroidNotificationSound(
  //         TextConfig.DEFAULT_ANDROID_NEW_ORDER_SOUND),
  //   );
  // }

  // static IOSNotificationDetails iOSPlatformChannelSpecificsForNewOrder(
  //     {String? sound}) =>
  //     IOSNotificationDetails();
  // static const IOSNotificationDetails iOSPlatformChannelSpecifics =
  // IOSNotificationDetails();

  /// NEW ORDER NOTIFICATION CUSTOM SOUND
  // static NotificationDetails platformChannelSpecificsForNewOrder =
  //     NotificationDetails(
  //       // android: androidPlatformChannelSpecificsForNewOrder(sound: sound),
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecificsForNewOrder,
  //     );

  ///OTHER NOTIFICATION SYSTEM DEFAULT SOUND
  NotificationDetails platformChannelSpecifics() => NotificationDetails(
        android: androidPlatformChannelSpecifics(),
        // iOS: iOSPlatformChannelSpecifics,
      );

  inItNotification(BuildContext context) async {
    print('CALL......................');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    /// On notification click when app is open (local notification click)
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      // onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     Map<String, dynamic> messageData = json.decode(payload);
      //
      //     if (messageData != null) {
      //       if (notiIds.contains(messageData['entity'])) {
      //         return;
      //       } else {
      //         notiIds.add(messageData['entity']);
      //       }
      //
      //       routeScreenOnNotificationClick(
      //         context: context,
      //         data: messageData,
      //       );
      //     }
      //   }
      // }
    );
  }

  notificationPermission() async {
    await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);
  }

  onNotification(BuildContext context) {
    // on notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        isSoundOn = true;
        await flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, platformChannelSpecifics(),
            payload: jsonEncode(message.data));
        print('notification data ' + jsonEncode(message.data));
      }
    });

    /// when app is in background and user tap on it.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message != null) {
        Map<String, dynamic> messageData = message.data;
        print('dats is ${message.data}');
        if (notiIds.contains(messageData['entity'])) {
          return;
        } else {
          notiIds.add(messageData['entity']);
        }
        routeScreenOnNotificationClick(
          context: context,
          data: messageData,
        );
      }
    });

    /// when app is in terminated and user tap on it.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      print('APP KILLED MODE FIRE...........');
      if (message != null) {
        Map<String, dynamic> messageData = message.data;
        print('ON MESSAGE APP KILLED MODE FIRE...........');

        /* if (messageData != null) {
          if (notiIds.contains(messageData['entity'])) {
            return;
          } else {
            notiIds.add(messageData['entity']);
          }

          // routeScreenOnNotificationClick(
          //   context: context,
          //   data: messageData,
          // );
        }*/
      }
    });
  }

  static Future<void> sendMessage(
      {required String receiverFcmToken,
      required String msg,
      required String title,
      Map<String, dynamic>? data}) async {
    /// PROD MODE SERVER KEY
    var serverKey =
        'AAAA1sVllNI:APA91bGXmwGmZoOtfQfNRoFyq-uPHCK_7R9easl6cBy8P-k3f8QAlRdFCr1lY--XMI5a-fu4wZc-Fuxw8ou2m5cOdi_J-B4Np43M99_8A1aa9zNaxBDjsLNgLdHPn9-ujMvyUEXCaCdP';
    // 'AAAARAiPRRE:APA91bFjBkRIMPeSkMndxxDYmpmdAv4v_dt9J8chir_zGTSz_g7LniPLqyIhI2U9A6TJTxPk44o84Mq0XEJ2z6SC1lbDILYOgXCnIf9bjrwwTkYBvLhwgzFbol34ctWIUpnhbmY8e9kv';
    String body = jsonEncode(
      <String, dynamic>{
        "notification": {
          "body": msg,
          "title": title,
          "badge": "1",
          "sound": "default",
          // "sound": "simple_short",
        },
        "priority": "high",
        "data": data ??
            <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              "status": "done",
            },
        "to": receiverFcmToken,
      },
    );
    log('NOTI. REQ BODY : => $body');
    if (receiverFcmToken == '') {
      return;
    }
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: body,
      );
      log("RESPONSE CODE ${response.statusCode}");
      log("RESPONSE BODY ${response.body}");
    } catch (e) {
      print("error push notification");
    }
  }

  Future<void> routeScreenOnNotificationClick(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {
    ///

    ///

/*    if (data['notification_type'] == 'chat') {
      print('DATA :=>$data');
      Order order = Order.fromJson(jsonDecode(data['order']));
      ChatWith chatWith = ChatWith.fromJson(jsonDecode(data['chat_with_data']));
      bool chatWithCustomer = data['chat_with'] == ChatWithEnum.Customer.name;
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ChatScreen(
      //               receiver: chatWith,
      //               order: order,
      //               chatWithGolfer: chatWithCustomer,
      //             )));
      Get.to(() => ChatScreen(
            receiver: chatWith,
            order: order,
            chatWithGolfer: chatWithCustomer,
          ));
    }
    else if (data['notification_type'] == 'order') {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => ScreenContainer(
      //           selectedIndex: 1,
      //         )));
      Get.off(() => ScreenContainer(
            selectedIndex: 1,
          ));
    }*/
  }
}
