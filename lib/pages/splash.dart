import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meet_me/pages/auth/multi_page_provider.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_manager.dart';
import '../constants/prefs.dart';
import '../helpers/connection_utils.dart';
import '../models/notification_model.dart';
import '../models/push_notification.dart';
import '../models/result_model.dart';
import 'auth/phoneauth.dart';

class Splash extends StatefulWidget {
  static String routeName = "/splash";
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  DateTime? currentBackPressTime;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String strtoken = "", id = "";
  bool _isLoggedIn = false, _isOnboardSeen = false;
  int _totalNotifications = 0;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    getsharedpref();
    Timer(
      const Duration(seconds: 3),
      () => registerNotification(),
    );
  }

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    bool _isOnboardngSeen = prefs.getBool(Prefs.isOnboardngSeen) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID) ?? "";

    print(sid);
    setState(() {
      id = sid;
      _isLoggedIn = status;
      _isOnboardSeen = _isOnboardngSeen;
    });
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    // String? token = await FirebaseMessaging.instance.getToken()
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        strtoken = token.toString();
      });
      if (_isLoggedIn) {
        updateToken(context, id);
      } else {
        navigateUser();
      }
      print(token);
    });

    FirebaseMessaging.onBackgroundMessage(
        (message) => _firebaseMessagingBackgroundHandler(message));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? _notification = message.notification;
      // AndroidNotification _android = message.notification?.android;

      // Parse the message received
      PushNotification notification = PushNotification(
        title: _notification?.title,
        body: _notification?.body,
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });

      if (_notificationInfo != null) {
        // For displaying the notification as an overlay

        showOverlayNotification((context) {
          return notificationBuilder();
        }, duration: Duration(seconds: 3), position: NotificationPosition.top);
      }
    });
  }

  Widget notificationBuilder() {
    return Card(
      margin: EdgeInsets.only(top: 20.0),
      elevation: 2,
      color: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
          title: Text(_notificationInfo!.title!, style: black14BoldTextStyle),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle:
              Text(_notificationInfo!.body!, style: black13MediumTextStyle)),
    );
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
      firebaseCloudMessaging_Listeners();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: blackColor.withOpacity(0.7),
        child: WillPopScope(
          onWillPop: () async {
            bool backStatus = onWillPop();
            if (backStatus) {
              exit(0);
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 110,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }

  navigateUser() async {
    if (_isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomBar()),
      );
    } else if (_isOnboardSeen) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Phoneauth()),
        (Route<dynamic> route) => false,
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Phoneauth()),
      // );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MultiPageProvider()),
      // );
    }
  }

  Future<void> updateToken(context, String id) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          final ResultModel resultModel =
              await API_Manager.addUsertoken(id, strtoken);
          print(resultModel);
          if (resultModel.error != true) {
            navigateUser();
          } else {
            navigateUser();
          }
        } on Exception catch (_, e) {
          print(e.toString());
        }
      } else {
        // No-Internet Case
        showSnackBar(context, "Please check your internet connection");
        // UIUtils.showWhiteSnackbar(context, 'Please check your internet connection');
      }
    });
  }

  NotificationModel getNotification(String values) {
    String strdata = values;
    strdata = strdata.replaceAll("(", "");
    strdata = strdata.replaceAll(")", "");
    return notificationModelFromJson(strdata);
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
