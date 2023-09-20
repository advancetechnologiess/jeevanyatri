import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meet_me/models/push_notification.dart';
import '../main.dart';
import '../models/notification_model.dart';
import '../pages/screens.dart';

class NotificationManager{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  late final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
  );
  String initialRoute = MyApp.routeName;

  AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
          ) async {
        PushNotification(
          title: title,
          body: body,
        );
      });

  NotificationModel getNotification(String values) {
    String strdata = values;
    strdata = strdata.replaceAll("(", "");
    strdata = strdata.replaceAll(")", "");
    return notificationModelFromJson(strdata);
  }

  Future<void> _createNotificationChannel() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(
      'com.advance.jeevanyatri',
      'JeevanYatri',
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> showNotificationWithNoBody(RemoteMessage message) async {


    await Firebase.initializeApp();
    _createNotificationChannel();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    // FirebaseMessaging.instance.subscribeToTopic("android");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      // RemoteNotification? notification = message.notification;
      print('RemoteNotification : '+message.toString());
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (message.notification != null) {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.advance.jeevanyatri', 'JeevanYatri',
            channelDescription: 'JeevanYatri',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
        const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: DarwinNotificationDetails(presentSound: true)
        );
        String  myPayload = "";
        // if(notification.android!.link != null || notification.android!.link != ""){
        //   myPayload = notification.android!.clickAction! + "/" + notification.android!.link!;
        // } else {
        //   myPayload = notification.android!.clickAction!;
        // }

        flutterLocalNotificationsPlugin.show(
            0, message.notification?.title, message.notification?.body, platformChannelSpecifics,
            payload: myPayload);

        // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (NotificationResponse? notificationResponse) async {
            if (notificationResponse!= null) {
              debugPrint('notification payload main: ${notificationResponse.payload}');

              runApp(
                MaterialApp(
                  initialRoute: initialRoute,
                  debugShowCheckedModeBanner: false,
                  routes: <String, WidgetBuilder>{
                    Splash.routeName: (_) => Splash()
                  },
                ),
              );

              String mypayloads = "";
              String payload = notificationResponse.payload!;
              if(payload.contains("upcomingevents")){
                mypayloads = "upcomingevents";
              } else if(payload.contains("newsandevents")){
                mypayloads = "newsandevents";
              } else {
                mypayloads = "payment";
              }

              // if(mypayloads == "payment"){
              //   runApp(
              //     MaterialApp(
              //       initialRoute: initialRoute,
              //       debugShowCheckedModeBanner: false,
              //       routes: <String, WidgetBuilder>{
              //         DashboardScreen.routeName: (_) => DashboardScreen(10)
              //       },
              //     ),
              //   );
              // } else if(mypayloads == "upcomingevents"){
              //
              //   String id = "";
              //   if(payload.contains("/")){
              //     id = payload.replaceAll("upcomingevents/", "");
              //   }
              //
              //   print("id "+id);
              //
              //   runApp(
              //     MaterialApp(
              //       initialRoute: initialRoute,
              //       debugShowCheckedModeBanner: false,
              //       routes: <String, WidgetBuilder>{
              //         UpcomingdetailScreen.routeName: (_) => UpcomingdetailScreen(id,"","not")
              //       },
              //     ),
              //   );
              // } else if(mypayloads == "newsandevents"){
              //
              //   String id = "";
              //   if(payload.contains("/")){
              //     id = payload.replaceAll("newsandevents/", "");
              //   }
              //
              //   runApp(
              //     MaterialApp(
              //       initialRoute: initialRoute,
              //       debugShowCheckedModeBanner: false,
              //       routes: <String, WidgetBuilder>{
              //         EventdetailsScreen.routeName: (_) => EventdetailsScreen(id,"","not")
              //       },
              //     ),
              //   );
              // } else {
              //   runApp(MyApp(notificationAppLaunchDetails));
              // }
            }
            // selectedNotificationPayload = payload;
            // selectNotificationSubject.add(payload);

          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage messagenew) {
      if (messagenew.notification!.android!.clickAction == 'noevent') {
        // Navigator.pushNamed(context, '/notiofication',
        //     arguments: ChatArguments(notification);
        print("Working");
        // IntentUtils.fireIntent(context, FacilitydetailScreen("about","AboutUs"));
      }
    });

    print("Message "+FirebaseMessaging.onMessage.first.toString());

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print("fireabse closed app msg "+message!.notification.toString());

      if (message.data.isNotEmpty) {
        print("Working");

      }
    });


  }
}
