import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      context.read<AuthCubit>().autoLogin();

      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/sign-in', (route) => false);
      } else {
        context.read<AuthCubit>().getCurrentUser(user.uid);
        print('=============== INI USER: $user');
        Navigator.pushNamedAndRemoveUntil(
            context, '/nav-bar', (route) => false);
      }
    });
    super.initState();
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
                  Image.asset('assets/images/logo-marcha-img.png', width: 101.67.w, height: 80.h,),
                  SizedBox(height: 10.h,),
                  Text('MARCHA', style: titleSplashh,),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                Text('By', style: bySplash,),
                SizedBox(height: 5.h,),
                Text('ORBIT', style: orbitSplash,),
                SizedBox(height: 35.h,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
