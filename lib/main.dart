import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/cubit/page_cubit.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:marcha_branch/ui/history/history_page.dart';
import 'package:marcha_branch/ui/onboard/onboard_page.dart';
import 'package:marcha_branch/ui/onboard/splash_page.dart';
import 'package:marcha_branch/ui/onboard/v_login.dart';
import 'package:marcha_branch/ui/onboard/v_signup.dart';
import 'package:marcha_branch/ui/split_bill/splitBill_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  // // await requestPermission();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDKyW4hEbNdrdADXREuBgjTFsRptivD9Xo",
          // "AAAA9XZ2bVE:APA91bGXuEwzcU9ncfQhipfeijm2G6bc74Mh8WElbqOYqZPcs8x-Wtf7C8VVCJC16PLvUglmZpAlENGn8dpfif2fEnfriHjX6fO4yrU1yyZeuZWxlbskG6HEjDElW4fbm71cthGojobw",
          appId: "1:1054254460241:android:0c2c84eed318e5268cb770",
          messagingSenderId: "1054254460241",
          projectId: "marcha-branch"));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // String? token = await FirebaseMessaging.instance.getToken();

  // print('INI TOKEN');
  // print(token);

  // // await loadFCM();

  SharedPreferences pref = await SharedPreferences.getInstance();
  initScreen = pref.getInt('initScreen');
  await pref.setInt('initScreen', 1);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/splash': (context) => SplashPage(),
            '/onBoarding': (context) => OnBoardPage(),
            '/sign-in': (context) => LoginPage(),
            '/sign-up': (context) => SignupPage(),
            '/nav-bar': (context) => BotNavBar(),
            '/split-bill': (context) => SplitBillPage(),
            // '/friend-page': (context) => FriendsPage(),
            '/history-page': (context) => HistoryPage(),
          },
          initialRoute:
              initScreen == 0 || initScreen == null ? '/onBoarding' : '/splash',
        ),
      ),
    );
  }
}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
  print(message.toMap());
}

Future<void> loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

Future<void> listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  });
}
