import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/onboard/v_signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;
  final String errorMsg = "";
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    String? emailValidator(value) {
      var pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (value.isEmpty) return 'Masukkan Email Anda!';
      if (!regex.hasMatch(value)) {
        return 'Mohon Masukkan Email yang Valid!';
      } else {
        return null;
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Image.asset('assets/images/login-bg-top.png'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Masuk",
                    style: titleLog,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  // Email Field
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: labelLog,
                      border: OutlineInputBorder(),
                    ),
                    controller: _email,
                    validator: emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Password Field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: labelLog,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          // color: Theme.of(context).primaryColorDark,
                          color: HexColor('#9D9D9D'),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    controller: _password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Masukkan Kata Sandi Anda!';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  // Button Masuk
                  _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: 320.w,
                              height: 42.h,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(buttonMain),
                                ),
                                onPressed: () {
                                  null;
                                  // context.read<AuthCubit>().signIn(
                                  //     email: _email.text,
                                  //     password: _password.text);
                                  // return login();
                                },
                                child: Text(
                                  'Masuk',
                                  style: textButton,
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        null;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ForgotPasswordPage(),
                        //     ));
                      },
                      child: Text(
                        'Lupa Password?',
                        style: linkLog,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          color: HexColor('#A6A6A6'),
                        ),
                      ),
                      Text(
                        'Atau',
                        style: orTxt,
                      ),
                      Container(
                        height: 1.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          color: HexColor('#A6A6A6'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  // Button Google
                  InkWell(
                    onTap: () async {
                      await context.read<AuthCubit>().googleLogin();
                      final GoogleSignIn _googleSignIn = GoogleSignIn();
                      final isSignIn = await _googleSignIn.isSignedIn();

                      try {
                        if (isSignIn) {
                          print('MASUK IS SIGN IN');
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => BotNavBar(),
                          //     ));
                          Navigator.pushReplacementNamed(context, '/nav-bar');
                        } else {
                          print('GAK MASUK IS SIGN IN');
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user exists with this email.');
                        } else if (e.code == 'wrong-password') {
                          print('Incorrect Password.');
                        }
                        setState(() {
                          _loading = false;
                        });
                      }
                      // context.read<AuthCubit>().googleLogin();
                      // Timer(Duration(seconds: 4), () {
                      //   return checkLogin();
                      // });
                      // await AuthService().googleLogin();
                      // User? isSignIn = FirebaseAuth.instance.currentUser;
                      // Stream<User?> isSignIn2 = isSignI;

                      // await AuthService().signInwithGoogle();
                      // Timer(Duration(seconds: 5), () async {
                      //   final GoogleSignIn _googleSignIn = GoogleSignIn();
                      //   final isSignIn = await _googleSignIn.isSignedIn();

                      //   try {
                      //     if (isSignIn) {
                      //       print('MASUK IS SIGN IN');
                      //       Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => BotNavBar(),
                      //           ));
                      //     } else {
                      //       print('GAK MASUK IS SIGN IN');
                      //     }
                      //   } on FirebaseAuthException catch (e) {
                      //     if (e.code == 'user-not-found') {
                      //       print('No user exists with this email.');
                      //     } else if (e.code == 'wrong-password') {
                      //       print('Incorrect Password.');
                      //     }
                      //     setState(() {
                      //       _loading = false;
                      //     });
                      //   }
                      // });
                    },
                    child: Container(
                      width: 320.w,
                      height: 42.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 7.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: HexColor('#9D9D9D'),
                        ),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/icon-google.png'),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            'Hubungkan dengan Google',
                            style: normalTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum mendaftar? ',
                        style: smallTxt,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ));
                        },
                        child: Text(
                          'Daftar',
                          style: linkLog,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // User? user = FirebaseAuth.instance.currentUser;
    // Stream userStream = user as Stream;

    // return StreamBuilder(
    //   stream: userStream,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return BotNavBar();
    //     } else {
    //       return ScreenUtilInit(
    //         designSize: const Size(360, 640),
    //         builder: () => MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             key: _scaffoldKey,
    //             backgroundColor: Colors.white,
    //             body: ListView(
    //               children: [
    //                 Image.asset('assets/images/login-bg-top.png'),
    //                 Container(
    //                   padding: EdgeInsets.symmetric(horizontal: 20.w),
    //                   child: Form(
    //                     key: _formKey,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           "Masuk",
    //                           style: titleLog,
    //                         ),
    //                         SizedBox(
    //                           height: 18.h,
    //                         ),
    //                         // Email Field
    //                         TextFormField(
    //                           enabled: false,
    //                           keyboardType: TextInputType.emailAddress,
    //                           decoration: InputDecoration(
    //                             labelText: 'Email',
    //                             labelStyle: labelLog,
    //                             border: OutlineInputBorder(),
    //                           ),
    //                           controller: _email,
    //                           validator: emailValidator,
    //                           autovalidateMode:
    //                               AutovalidateMode.onUserInteraction,
    //                         ),
    //                         SizedBox(
    //                           height: 20.h,
    //                         ),
    //                         // Password Field
    //                         TextFormField(
    //                           enabled: false,
    //                           decoration: InputDecoration(
    //                             labelText: 'Password',
    //                             labelStyle: labelLog,
    //                             border: OutlineInputBorder(),
    //                             suffixIcon: IconButton(
    //                               icon: Icon(
    //                                 _passwordVisible
    //                                     ? Icons.visibility
    //                                     : Icons.visibility_off,
    //                                 // color: Theme.of(context).primaryColorDark,
    //                                 color: HexColor('#9D9D9D'),
    //                               ),
    //                               onPressed: () {
    //                                 setState(() {
    //                                   _passwordVisible = !_passwordVisible;
    //                                 });
    //                               },
    //                             ),
    //                           ),
    //                           obscureText: !_passwordVisible,
    //                           controller: _password,
    //                           validator: (value) {
    //                             if (value!.isEmpty) {
    //                               return 'Masukkan Kata Sandi Anda!';
    //                             } else {
    //                               return null;
    //                             }
    //                           },
    //                           autovalidateMode:
    //                               AutovalidateMode.onUserInteraction,
    //                         ),
    //                         SizedBox(
    //                           height: 24.h,
    //                         ),
    //                         // Button Masuk
    //                         _loading
    //                             ? const Center(
    //                                 child: CircularProgressIndicator(
    //                                   valueColor: AlwaysStoppedAnimation<Color>(
    //                                       Colors.blue),
    //                                 ),
    //                               )
    //                             : BlocBuilder<AuthCubit, AuthState>(
    //                                 builder: (context, state) {
    //                                   return SizedBox(
    //                                     width: 320.w,
    //                                     height: 42.h,
    //                                     child: TextButton(
    //                                       style: ButtonStyle(
    //                                         backgroundColor:
    //                                             MaterialStateProperty.all(
    //                                                 buttonMain),
    //                                       ),
    //                                       onPressed: () {
    //                                         null;
    //                                         // context.read<AuthCubit>().signIn(
    //                                         //     email: _email.text,
    //                                         //     password: _password.text);
    //                                         // return login();
    //                                       },
    //                                       child: Text(
    //                                         'Masuk',
    //                                         style: textButton,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               ),
    //                         SizedBox(
    //                           height: 12.h,
    //                         ),
    //                         Align(
    //                           alignment: Alignment.centerRight,
    //                           child: TextButton(
    //                             onPressed: () {
    //                               null;
    //                               // Navigator.push(
    //                               //     context,
    //                               //     MaterialPageRoute(
    //                               //       builder: (context) => ForgotPasswordPage(),
    //                               //     ));
    //                             },
    //                             child: Text(
    //                               'Lupa Password?',
    //                               style: linkLog,
    //                             ),
    //                           ),
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Container(
    //                               height: 1.h,
    //                               width: 130.w,
    //                               decoration: BoxDecoration(
    //                                 color: HexColor('#A6A6A6'),
    //                               ),
    //                             ),
    //                             Text(
    //                               'Atau',
    //                               style: orTxt,
    //                             ),
    //                             Container(
    //                               height: 1.h,
    //                               width: 130.w,
    //                               decoration: BoxDecoration(
    //                                 color: HexColor('#A6A6A6'),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         SizedBox(
    //                           height: 24.h,
    //                         ),
    //                         // Button Google
    //                         InkWell(
    //                           onTap: () async {
    //                             // context.read<AuthCubit>().googleLogin();
    //                             // Timer(Duration(seconds: 4), () {
    //                             //   return checkLogin();
    //                             // });
    //                             await AuthService().googleLogin();
    //                             // User? isSignIn = FirebaseAuth.instance.currentUser;
    //                             // Stream<User?> isSignIn2 = isSignI;

    //                             await AuthService().signInwithGoogle();
    //                             final GoogleSignIn _googleSignIn =
    //                                 GoogleSignIn();

    //                             final isSignIn =
    //                                 await _googleSignIn.isSignedIn();
    //                             try {
    //                               if (isSignIn) {
    //                                 print('MASUK IS SIGN IN');
    //                                 Navigator.pushReplacement(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                       builder: (context) => BotNavBar(),
    //                                     ));
    //                               } else {
    //                                 print('GAK MASUK IS SIGN IN');
    //                               }
    //                             } on FirebaseAuthException catch (e) {
    //                               print('======= MASUK CATCH ');
    //                               if (e.code == 'user-not-found') {
    //                                 print('No user exists with this email.');
    //                               } else if (e.code == 'wrong-password') {
    //                                 print('Incorrect Password.');
    //                               }
    //                               setState(() {
    //                                 _loading = false;
    //                               });
    //                             }
    //                           },
    //                           child: Container(
    //                             width: 320.w,
    //                             height: 42.h,
    //                             padding: EdgeInsets.symmetric(
    //                                 vertical: 7.h, horizontal: 20.w),
    //                             decoration: BoxDecoration(
    //                               border: Border.all(
    //                                 color: HexColor('#9D9D9D'),
    //                               ),
    //                               borderRadius: BorderRadius.circular(5.r),
    //                             ),
    //                             child: Row(
    //                               children: [
    //                                 Image.asset(
    //                                     'assets/images/icon-google.png'),
    //                                 SizedBox(
    //                                   width: 12.w,
    //                                 ),
    //                                 Text(
    //                                   'Hubungkan dengan Google',
    //                                   style: normalTxt,
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(
    //                               'Belum mendaftar? ',
    //                               style: smallTxt,
    //                             ),
    //                             TextButton(
    //                               onPressed: () {
    //                                 Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                       builder: (context) => SignupPage(),
    //                                     ));
    //                               },
    //                               child: Text(
    //                                 'Daftar',
    //                                 style: linkLog,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}

// snackBarSuccesful() {
//   return SnackBar(
//     content: Text(
//       "Login Berhasil!",
//       style: TextStyle(color: Colors.white),
//     ),
//     backgroundColor: Colors.lightBlue,
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(23),
//     ),
//   );
// }

// snackBarUnSuccesful() {
//   return SnackBar(
//     content: const Text(
//       "Email atau Password salah",
//       style: TextStyle(color: Colors.white),
//     ),
//     backgroundColor: Colors.redAccent,
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(23),
//     ),
//   );
// }
