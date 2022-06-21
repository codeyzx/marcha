import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/ui/onboard/login_page.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F7F7FA"),
        body: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            color: HexColor("#F7F7FA"),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 78.15.h,
              ),
              Center(
                child: Image.asset(
                  "assets/logo.jpeg",
                  width: 277.w,
                  height: 205.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 75.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 74.w, right: 75.w),
                child: Text(
                  "Selamat Datang di Schoop",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 34.h),
              Padding(
                padding: EdgeInsets.only(left: 74.w, right: 75.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras suscipit neque at mi eleifend, in fermentum mi pellentesque. Maecenas quis velit faucibus, congue magna eu, mattis odio. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam laoreet enim odio, ut",
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 31.h,
              ),
              SizedBox(
                width: 281.w,
                height: 42.h,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          print("click register");
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }));
                        },
                        child: Container(
                          width: 155.w,
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: HexColor("#474747").withOpacity(0.50),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                              child: Text(
                            "Register",
                          )),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("click signin");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                      child: Container(
                        width: 147.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: HexColor("#F2C94C"),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                            child: Text(
                          "Sign in",
                        )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
