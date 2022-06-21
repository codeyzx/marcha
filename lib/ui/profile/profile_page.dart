
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/else/development_page.dart';
import 'package:marcha_branch/ui/pin/otp_update.dart';
import 'package:marcha_branch/ui/profile/profile_edit_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error),
              ),
            );
          } else if (state is AuthInitial) {
            Navigator.pushReplacementNamed(context, '/sign-in');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return ListView(
              children: [
                Container(
                  width: 1.sw,
                  height: 165.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: HexColor('#9D20FF').withOpacity(0.10),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: (snapshot.data!)
                                  .docs
                                  .map(
                                    (e) => Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Image.network(
                                            // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                            // state.user.photo,
                                            e['photo'],
                                            width: 54.w,
                                            height: 54.h,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 250.w,
                                                child: Text(
                                                  // "Muhammad Emirsyah ",
                                                  // state.user.name,
                                                  e['name'],
                                                  style: nameProfile,
                                                )),
                                            SizedBox(
                                                width: 250.w,
                                                child: Text(
                                                  // "Muhammad Emirsyah ",
                                                  // "@${state.user.email}",
                                                  e['email'],
                                                  style: usernameProfile,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        "Hello Marchanians, Welcome!",
                        style: sayHelloProfile,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "16",
                            style: manyFriendProfile,
                          ),
                          Text(" Friends", style: subFriendProfile),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Akunmu",
                        style: itemTitleProfile,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/user-profile.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Edit Profile",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpUpdate(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/lock-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ubah PIN",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Text(
                        "Bantuan",
                        style: itemTitleProfile,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DevelopmentPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/message-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bantuan",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DevelopmentPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/report-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Laporkan Masalah",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Text(
                        "Lainnya",
                        style: itemTitleProfile,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DevelopmentPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/order-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ketentuan Layanan",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DevelopmentPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/shield-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kebijakan Privasi",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DevelopmentPage(),
                              ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/star-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Beri Rating",
                                    style: itemProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#231F20'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 42.h,
                      ),
                      InkWell(
                        onTap: () async {
                          // context.read<AuthCubit>().signOut();
                          context.read<AuthCubit>().signOut();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logout-icon.png',
                              width: 25.w,
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 282.w,
                              height: 33.h,
                              padding: EdgeInsets.only(bottom: 5.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: HexColor('#E5E5E5'),
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Logout",
                                    style: logoutProfile,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: HexColor('#DB3F3F'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
