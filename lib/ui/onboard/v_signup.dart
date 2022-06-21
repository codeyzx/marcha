import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/home/home.dart';
import 'package:marcha_branch/ui/onboard/v_login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  String errorMsg = "";

  bool _loading = false;
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
  }

  void signup() async {
    FormState? form = _formKey.currentState;
    if (_formKey.currentState!.validate()) {
      form!.save();
      setState(() {
        _loading = true;
      });
    }
    try {
      print('======= MASUK TRY ');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text);

      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    } catch (error) {
      print('======= MASUK CATCH ');
      print(error);
      if (mounted) {
        setState(() {
          _loading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(snackBarUnSuccesful());
      }
    }
    return null;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _repeatpasswordVisible = false;
  final bool _acceptTerms = false;

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

    const loadIndicator = Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
    return Scaffold(
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
                    "Daftar",
                    style: titleLog,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  // Name Field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      labelStyle: labelLog,
                      border: OutlineInputBorder(),
                    ),
                    controller: _name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Masukkan Nama Lengkap Anda!";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (input) {
                      _name.text = input!;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Email Field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: labelLog,
                      border: OutlineInputBorder(),
                    ),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
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
                          color: HexColor('#9D9D9D'),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kata Sandi tidak boleh kosong';
                      }
                      if (value.length < 6) {
                        return 'Minimal Kata Sandi 6 Karakter';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !_passwordVisible,
                    controller: _password,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Confirm Password Field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      labelStyle: labelLog,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _repeatpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: HexColor('#9D9D9D'),
                        ),
                        onPressed: () {
                          setState(() {
                            _repeatpasswordVisible = !_repeatpasswordVisible;
                          });
                        },
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !_repeatpasswordVisible,
                    controller: _confirm,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  // Button Daftar
                  _loading
                      ? loadIndicator
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
                                  // context.read<AuthCubit>().signUp(
                                  //     email: _email.text,
                                  //     password: _password.text,
                                  //     name: _name.text);
                                  // return signup();
                                },
                                child: Text(
                                  'Daftar Sekarang',
                                  style: textButton,
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(
                    height: 12.h,
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
                        'Sudah punya akun? ',
                        style: smallTxt,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(
                          'Masuk',
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
  }
}
