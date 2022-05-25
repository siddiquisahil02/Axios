import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_manager/appRouter.dart';
import 'package:society_manager/constants.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
  // sound: AndroidNotificationSound(),
  showBadge: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  Fluttertoast.showToast(msg: message.data['action']);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? payload = notificationAppLaunchDetails!.payload;
  print(payload);

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey(debugLabel: "Main Navigator");

  void storeToken(String? token) async {
    print("FCM Token: $token");
    if (auth.currentUser != null) {
      await firebase
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('FCM')
          .doc('token')
          .set({'token': token});
    }
  }

  void onSelectNotification(String? payload) async {
    print(payload);
    if(payload!=null){
      navigatorKey.currentState?.pushNamed(
        '/approved',arguments: payload
      );
    }else{
      print("Empty Payload");
    }
  }

  @override
  void initState() {
    super.initState();
    
    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher")
        ),
      onSelectNotification: onSelectNotification
    );
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      String action = message.data['action'];
      print(message.data);
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                playSound: true,
                icon: "@mipmap/ic_launcher",
              ),
              iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                subtitle: notification.body,
              ),
            ),
          payload: action,
        );
      }
      // List<Map<String,dynamic>> noti = (box.read("noti")??[]).cast<Map<String,dynamic>>()??[];
      // noti.add({
      //   "title":notification!.title,
      //   "body":notification.body,
      //   "time":DateTime.now().millisecondsSinceEpoch
      // });
      // await box.write("noti",noti);
    });

    FirebaseMessaging.instance.getToken().then(storeToken);

    FirebaseMessaging.instance.onTokenRefresh.listen(storeToken);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message!=null){
        String action = message.data['action'];
        Fluttertoast.showToast(msg:"Initial $action");
        navigatorKey.currentState?.pushNamed('/approved',arguments: action);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      String action = message.data['action'];
      Fluttertoast.showToast(msg: action);
      navigatorKey.currentState?.pushNamed('/approved',arguments: action);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Axios',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Colors.white,
          appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold))),
      onGenerateRoute: widget.appRouter.generateRoute,
    );
  }
}
