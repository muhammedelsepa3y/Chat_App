import 'package:chat/Services/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'navigation_service.dart';

@pragma('vm:entry-point')
class NotificationService{
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    openNotification(message.data);
  }


  static void openNotification(Map payloadObj) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if(payloadObj['id'] != null){
      Provider.of<UserProvider>(NavigationService.context!, listen: false).getAllChats();
      var chatWithUID = payloadObj['id'];
      Provider.of<UserProvider>(NavigationService.context!, listen: false).getChatWithUser(chatWithUID, NavigationService.context!);
    }


  }
  static initMessagingServices() async {
    try {

      late AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'Chat',
        'Chat Notifications',
        showBadge: true,
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);



      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettingsIOS = DarwinInitializationSettings(
          requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,
          onDidReceiveLocalNotification: (id, title, body, payload) async {
          }
      );

      InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) async {

          if(response.payload != null){

              Provider.of<UserProvider>(NavigationService.context!, listen: false).getAllChats();
              var chatWithUID = response.payload;
              Provider.of<UserProvider>(NavigationService.context!, listen: false).getChatWithUser(chatWithUID, NavigationService.context!);


          }
        },


      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onMessage.listen((event) {
        print('Received FCM message: ${event.data}');
        flutterLocalNotificationsPlugin.show(
            event.hashCode,
            event.notification!.title,
            event.notification!.body,
            const NotificationDetails(
                android: AndroidNotificationDetails(
                  'Chat',
                  'Chat Notifications',
                  channelDescription: 'Chat Notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false,
                ),
                iOS: DarwinNotificationDetails(
                  sound: 'default',
                  subtitle: 'Chat',
                  badgeNumber: 1,
                  categoryIdentifier: 'Chat',
                  threadIdentifier: 'Chat',
                )
            ),
            payload: event.data['id']
        );

      });
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print('Received FCM message: ${event.data}');
        if(event.data['id'] != null){
          Provider.of<UserProvider>(NavigationService.context!, listen: false).getAllChats();
          var chatWithUID = event.data['id'];
          Provider.of<UserProvider>(NavigationService.context!, listen: false).getChatWithUser(chatWithUID, NavigationService.context!);
        }
      });

    } catch (e) {
      if (kDebugMode) {}
    }


  }



}
