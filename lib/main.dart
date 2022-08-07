import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:marcha_branch/ui/history/history_page.dart';
import 'package:marcha_branch/ui/onboard/onboard_page.dart';
import 'package:marcha_branch/ui/onboard/splash_page.dart';
import 'package:marcha_branch/ui/onboard/v_login.dart';
import 'package:marcha_branch/ui/onboard/v_signup.dart';
import 'package:marcha_branch/ui/split_bill/splitBill_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
String? uid;

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notif');

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDKyW4hEbNdrdADXREuBgjTFsRptivD9Xo",
          appId: "1:1054254460241:android:0c2c84eed318e5268cb770",
          messagingSenderId: "1054254460241",
          projectId: "marcha-branch"));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences pref = await SharedPreferences.getInstance();
  initScreen = pref.getInt('initScreen');
  uid = pref.getString('uid');
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
          create: (context) => AuthCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp(
          title: 'Marcha',
          debugShowCheckedModeBanner: false,
          routes: {
            '/splash': (context) => SplashPage(
                  sharedPreference: initScreen,
                  uid: uid,
                ),
            '/onBoarding': (context) => OnBoardPage(),
            '/sign-in': (context) => LoginPage(),
            '/sign-up': (context) => SignupPage(),
            '/nav-bar': (context) => BotNavBar(),
            '/split-bill': (context) => SplitBillPage(),
            '/history-page': (context) => HistoryPage(),
          },
          initialRoute: '/splash',
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
  try {
    await Hive.initFlutter();
    await Hive.openBox('notif');

    final box = Hive.box('notif');
    await box.add({
      'title': message.data['title'],
      'body': message.data['body'],
    });
  } catch (e) {
    print(e);
  }
}

Future<void> loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

Future<void> listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      try {
        await Hive.initFlutter();
        await Hive.openBox('notif');

        final box = Hive.box('notif');
        await box.add({
          'title': message.data['title'],
          'body': message.data['body'],
        });
      } catch (e) {
        print(e);
      }
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/logo',
          ),
        ),
      );
    }
  });
}
