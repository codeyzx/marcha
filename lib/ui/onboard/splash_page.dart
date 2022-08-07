import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/main.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  final int? sharedPreference;
  final String? uid;
  const SplashPage(
      {Key? key, required this.sharedPreference, required this.uid})
      : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkpoint();
    super.initState();
  }

  void checkpoint() {
    Timer(Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (widget.sharedPreference == 0 || widget.sharedPreference == null) {
        Navigator.pushReplacementNamed(context, '/onBoarding');
      } else {
        if (user != null) {
          context.read<AuthCubit>().getCurrentUser(user.uid);
          Navigator.pushReplacementNamed(context, '/nav-bar');
        } else if (uid != null) {
          context.read<AuthCubit>().getCurrentUser(widget.uid!);
          Navigator.pushReplacementNamed(context, '/nav-bar');
        } else {
          Navigator.pushReplacementNamed(context, '/sign-in');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-marcha-img.png',
                    width: 101.67.w,
                    height: 80.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'MARCHA',
                    style: titleSplashh,
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  'By',
                  style: bySplash,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'ORBIT',
                  style: orbitSplash,
                ),
                SizedBox(
                  height: 35.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
