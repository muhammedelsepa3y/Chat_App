import 'package:chat/Services/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../Components/flush_bar.dart';
import 'navigation_service.dart';

@pragma('vm:entry-point')
class NotificationService{
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    if(message.data['id'] != null){
      print ("new message, application: background, action: none");
      showNotification(message);

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
      InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
          if(response.payload != null){
            print ("new message, application: open or background, action: click");
            print('Received FCM message: ${response.payload}');
            var chatWithUID = response.payload;
            Provider.of<UserProvider>(NavigationService.context!, listen: false).getAllChats();
            Provider.of<UserProvider>(NavigationService.context!, listen: false).getChatWithUser(chatWithUID);
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
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        print('Received FCM message: ${message?.data}');
        var order = message?.data['id'];
        if (order != null ) {
          showFlushBar("New Message, You have a new message");
          if (NavigationService.context == null){
            return;
          }
          var userProvider=Provider.of<UserProvider>(NavigationService.context!, listen: false);
          userProvider.getChatWithUser(order);
        }
      });
      FirebaseMessaging.onMessage.listen((event) {
        print ("new message, application: open, action: none");
        print('Received FCM message: ${event.data}');
        showNotification(event);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print ("onMessageOpenedApp");
        print ("new message, application: background, action: click");
        print('Received FCM message: ${event.data}');
        if(event.data['id'] != null){
          print ("onOpenedApp");
          print (event.data['id']);
          Provider.of<UserProvider>(NavigationService.context!, listen: false).getAllChats();
          var chatWithUID = event.data['id'];
          Provider.of<UserProvider>(NavigationService.context!, listen: false).getChatWithUser(chatWithUID);
        }
      });

    } catch (e) {
      if (kDebugMode) {}
    }




  }
  static showNotification(event){
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
  }



}
