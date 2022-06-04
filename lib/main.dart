import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/cubit/page_cubit.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:marcha_branch/ui/create_group/createGroup_page.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';
import 'package:marcha_branch/ui/history/history_page.dart';
import 'package:marcha_branch/ui/onboard/onboard_page.dart';
import 'package:marcha_branch/ui/onboard/splash_page.dart';
import 'package:marcha_branch/ui/onboard/v_login.dart';
import 'package:marcha_branch/ui/onboard/v_signup.dart';
import 'package:marcha_branch/ui/split_bill/splitBill_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  initScreen = pref.getInt('initScreen');
  await pref.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
