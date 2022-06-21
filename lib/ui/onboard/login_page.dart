import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/ui/home/home.dart';
import 'package:marcha_branch/ui/onboard/forgot_password_page.dart';
import 'package:marcha_branch/ui/onboard/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    FormState? form = _formKey.currentState;
    if (_formKey.currentState!.validate()) {
      form!.save();
      setState(() {
        _loading = true;
      });
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text, password: _password.text);
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccesful());
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user exists with this email.');
      } else if (e.code == 'wrong-password') {
        print('Incorrect Password.');
      }
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBarUnSuccesful());
    }
    return null;
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final loadIndicator = Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );

    final signupDesc = Text(
      'Belum Punya Akun Schoop?',
      style: TextStyle(
        fontSize: 15.sp,
        fontFamily: 'Poppins',
        color: Colors.black,
        fontWeight: FontWeight.w400,
        wordSpacing: 1.0,
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );

    final forgot = GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 46.w, top: 3.h),
        child: Text(
          'Lupa Kata Sandi?',
          maxLines: 1,
          style: TextStyle(
            color: HexColor("#3a7bd5"),
            fontSize: 15.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ForgotPasswordPage();
        }));
      },
    );

    final daftar = FlatButton(
      padding: EdgeInsets.only(left: 0.5.w),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignupPage();
        }));
      },
      child: Text(
        'DAFTAR',
        style: TextStyle(
          color: HexColor("#3a7bd5"),
          fontFamily: 'Poppins',
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final masuk =
        BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is AuthSuccess) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/nav-bar', (route) => false);
      }
    }, builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        width: double.infinity,
        height: 55.h,
        child: RaisedButton(
          onPressed: () {
            context
                .read<AuthCubit>()
                .signIn(email: _email.text, password: _password.text);
            return login();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor("#39A2DB"), HexColor("#468df0")],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(7)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 500.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "MASUK",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      );
    });

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
      backgroundColor: HexColor("#F7F7FA"),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Center(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          width: 186.w,
                          height: 186.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo.jpeg"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "LOGIN",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 25.h),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5.w),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: HexColor("#303030"),
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: HexColor("#303030"),
                                  width: 1,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: IconTheme(
                                  data: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  child: Icon(
                                    Icons.email_rounded,
                                    color: HexColor("#F2C94C"),
                                  ),
                                ),
                                padding:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                              ),
                              labelText: "Email",
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                              ),
                              hintText: "user@example.com",
                            ),
                            controller: _email,
                            validator: emailValidator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5.w),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(
                                  color: HexColor("#303030"),
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: IconTheme(
                                  data: IconThemeData(
                                      color: Theme.of(context).primaryColor),
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: HexColor("#F2C94C"),
                                  ),
                                ),
                                padding:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                              ),
                              labelText: "Kata Sandi",
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                              ),
                              hintText: "Kata Sandi Anda!",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: _passwordVisible,
                            controller: _password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Masukkan Kata Sandi Anda!';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                              child: forgot,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 23.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: _loading
                              ? loadIndicator
                              : Container(
                                  child: masuk,
                                ),
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Row(
                          children: [
                            Container(
                              child: signupDesc,
                            ),
                            Container(
                              child: daftar,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

snackBarSuccesful() {
  return SnackBar(
    content: Text(
      "Login Berhasil!",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.lightBlue,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(23),
    ),
  );
}

snackBarUnSuccesful() {
  return SnackBar(
    content: Text(
      "Email atau Password salah",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(23),
    ),
  );
}
