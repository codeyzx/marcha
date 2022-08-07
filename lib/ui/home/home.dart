import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/home/notification_page.dart';
import 'package:marcha_branch/ui/home/topup_page.dart';
import 'package:marcha_branch/ui/request/request_page.dart';
import 'package:marcha_branch/ui/send/send_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../friends/friends_page.dart';
import '../groups/group_page.dart';
import '../history/history_page.dart';
import '../split_bill/splitBill_page.dart';
import '../virtucard/virtucard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<void> _launchInWebViewOrVC(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    }

    List<String> friends = [];
    int statusLength = 0;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference send = FirebaseFirestore.instance.collection('send');
    return Scaffold(
      backgroundColor: HexColor("#F8F6FF"),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            friends.add(state.user.email);
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(state.user.id)
                          .collection('friends')
                          .where('statusFriend', isEqualTo: true)
                          .where('statusRequest', isEqualTo: false)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            var okedek = snapshot.data!.docs.length;

                            for (var i = 0; i < okedek; i++) {
                              friends.add(
                                  snapshot.data!.docs[i]['email'].toString());
                            }
                          }
                          return SizedBox();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: users
                          .doc(state.user.id)
                          .collection('friends')
                          .where('statusFriend', isEqualTo: false)
                          .where('statusRequest', isEqualTo: true)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            var okedek = snapshot.data!.docs.length;

                            for (var i = 0; i < okedek; i++) {
                              friends.add(
                                  snapshot.data!.docs[i]['email'].toString());
                            }
                          }
                          return SizedBox();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: users
                          .where('email', isEqualTo: state.user.email)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            if (snapshot.data!.docs[0]['status'] != '') {
                              print('MASUK SINI');
                              final int address =
                                  snapshot.data!.docs[0]['status']['address'];
                              final int email =
                                  snapshot.data!.docs[0]['status']['email'];
                              final int nik =
                                  snapshot.data!.docs[0]['status']['nik'];
                              final int phone =
                                  snapshot.data!.docs[0]['status']['phone'];
                              final int presence =
                                  snapshot.data!.docs[0]['status']['presence'];

                              statusLength +=
                                  address + email + nik + phone + presence;
                            }
                          }
                          return Column(
                            children: (snapshot.data!)
                                .docs
                                .map((e) => Column(
                                      children: [
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 4, sigmaY: 4),
                                          child: Container(
                                            width: 1.sw,
                                            height: 240.h,
                                            decoration: BoxDecoration(
                                              color: buttonMain,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(30.r),
                                                bottomRight:
                                                    Radius.circular(30.r),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/header-bg.png'),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 17.w, left: 17.w),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 30.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                              child:
                                                                  Image.network(
                                                                e['photo'],
                                                                width: 35.w,
                                                                height: 35.h,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                          SizedBox(
                                                            width: 11.w,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Welcome Back",
                                                                style:
                                                                    txtWelcome,
                                                              ),
                                                              Text(
                                                                e['name'],
                                                                style:
                                                                    txtNameHome,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NotificationPage()));
                                                        },
                                                        icon: Container(
                                                          width: 35.w,
                                                          height: 35.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/icon_bell.png',
                                                              width: 16.w,
                                                              height: 19.5.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "Saldo Kamu",
                                                      style: subTitleWhite,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      convertToIdr(
                                                          e['balance']),
                                                      style: moneyWhiteHome,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 13.h,
                                                  ),
                                                  Center(
                                                    child: SizedBox(
                                                      width: 230.w,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SendPage(),
                                                                  ));
                                                              print(
                                                                  "tapped Send");
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 50.w,
                                                                  height: 50.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.40),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/icon_send.png',
                                                                      width:
                                                                          17.5.w,
                                                                      height:
                                                                          17.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Send",
                                                                  style:
                                                                      itemWhite,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RequestPage(),
                                                                  ));
                                                              print(
                                                                  "tapped Request");
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 50.w,
                                                                  height: 50.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.40),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/icon_download.png',
                                                                      width:
                                                                          35.5.w,
                                                                      height:
                                                                          35.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Request",
                                                                  style:
                                                                      itemWhite,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          TopUpPage(
                                                                            email:
                                                                                state.user.email,
                                                                            uid:
                                                                                state.user.id,
                                                                            name:
                                                                                state.user.name,
                                                                          )));
                                                              print(
                                                                  "tapped TopUp");
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 50.w,
                                                                  height: 50.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.40),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/icon_add.png',
                                                                      width:
                                                                          35.5.w,
                                                                      height:
                                                                          35.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Top Up",
                                                                  style:
                                                                      itemWhite,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, right: 20.w),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              e['status'] != ''
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          width: 1.sw,
                                                          height: 80.h,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                  color: HexColor(
                                                                          "#9D20FF")
                                                                      .withOpacity(
                                                                          0.10),
                                                                  blurRadius: 5,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      Offset(
                                                                          2, 2),
                                                                ),
                                                              ]),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Lengkapi Data Diri ($statusLength/5)',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await _launchInWebViewOrVC(
                                                                            Uri.parse('https://u.id/profile'));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Lengkapi',
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.purple),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                LinearPercentIndicator(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  // width:,
                                                                  animation:
                                                                      true,
                                                                  lineHeight:
                                                                      20.0,
                                                                  animationDuration:
                                                                      2500,
                                                                  percent: 0.8,
                                                                  center: Text(
                                                                    "${e['status']['percent']}.0 %",
                                                                    style: GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            11.sp),
                                                                  ),
                                                                  barRadius: Radius
                                                                      .circular(
                                                                          20),
                                                                  progressColor:
                                                                      Colors
                                                                          .purple,
                                                                  backgroundColor:
                                                                      Colors.purple[
                                                                          50],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 25.h,
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SplitBillPage(),
                                                          ));
                                                      print("tapped SplitBill");
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 55.w,
                                                          height: 55.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: HexColor(
                                                                '#DAE2FF'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/icon_split.png',
                                                              width: 30.w,
                                                              height: 30.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Split Bill",
                                                          style: itemBlack,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    GroupPage(),
                                                          ));
                                                      print("tapped group");
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 55.w,
                                                          height: 55.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: HexColor(
                                                                '#ECDAFF'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/icon_group.png',
                                                              width: 30.w,
                                                              height: 30.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Group",
                                                          style: itemBlack,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                VirtucardPage(),
                                                          ));
                                                      print("tapped Virtucard");
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 55.w,
                                                          height: 55.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: HexColor(
                                                                '#FFF2DA'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/icon_card.png',
                                                              width: 30.w,
                                                              height: 30.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Virtucard",
                                                          style: itemBlack,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            makeDismissible(
                                                          child:
                                                              DraggableScrollableSheet(
                                                                  initialChildSize:
                                                                      0.45,
                                                                  builder: (_,
                                                                          controller) =>
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              HexColor("#F6F6F6"),
                                                                          borderRadius:
                                                                              BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 44.w),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 10.h,
                                                                                  ),
                                                                                  Center(
                                                                                    child: Container(
                                                                                      width: 105.w,
                                                                                      height: 7.h,
                                                                                      decoration: BoxDecoration(
                                                                                        color: HexColor('#ECDAFF'),
                                                                                        borderRadius: BorderRadius.circular(10.r),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 18.h,
                                                                                  ),
                                                                                  Text(
                                                                                    'More',
                                                                                    style: moreTitleHome,
                                                                                  ),
                                                                                  SizedBox(height: 18.h),
                                                                                  SizedBox(
                                                                                    width: 1.sw,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.pushReplacementNamed(context, '/split-bill');

                                                                                            print("tapped SplitBill");
                                                                                          },
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 55.w,
                                                                                                height: 55.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: HexColor('#DAE2FF'),
                                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Image.asset(
                                                                                                    'assets/images/icon_split.png',
                                                                                                    width: 30.w,
                                                                                                    height: 30.h,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "Split Bill",
                                                                                                style: itemBlack,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                  builder: (context) => GroupPage(),
                                                                                                ));
                                                                                            print("tapped group");
                                                                                          },
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 55.w,
                                                                                                height: 55.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: HexColor('#ECDAFF'),
                                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Image.asset(
                                                                                                    'assets/images/icon_group.png',
                                                                                                    width: 30.w,
                                                                                                    height: 30.h,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "Group",
                                                                                                style: itemBlack,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                  builder: (context) => VirtucardPage(),
                                                                                                ));
                                                                                            print("tapped Virtucard");
                                                                                          },
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 55.w,
                                                                                                height: 55.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: HexColor('#FFF2DA'),
                                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Image.asset(
                                                                                                    'assets/images/icon_card.png',
                                                                                                    width: 30.w,
                                                                                                    height: 30.h,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "Virtucard",
                                                                                                style: itemBlack,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 24.h),
                                                                                  SizedBox(
                                                                                    width: 162.w,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            print('FRIENDS DARI HOME: $friends');
                                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                              return FriendsPage(friends: friends);
                                                                                            }));
                                                                                            print("tapped friends");
                                                                                          },
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 55.w,
                                                                                                height: 55.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: HexColor('#FADAFF'),
                                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Image.asset(
                                                                                                    'assets/images/friend-icon.png',
                                                                                                    width: 30.w,
                                                                                                    height: 30.h,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "Friends",
                                                                                                style: itemBlack,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.pushReplacementNamed(context, '/history-page');

                                                                                            print("tapped history");
                                                                                          },
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 55.w,
                                                                                                height: 55.h,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: HexColor('#ECDAFF'),
                                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Image.asset(
                                                                                                    'assets/images/history-icon.png',
                                                                                                    width: 30.w,
                                                                                                    height: 30.h,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "History",
                                                                                                style: itemBlack,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                        ),
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    10.r),
                                                          ),
                                                        ),
                                                      );
                                                      print("tapped more");
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 55.w,
                                                          height: 55.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: HexColor(
                                                                '#DAFFE0'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/icon_more.png',
                                                              width: 30.w,
                                                              height: 30.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "More",
                                                          style: itemBlack,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Last Activity',
                                                    style: subTitleFriend,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                HistoryPage(),
                                                          ));
                                                    },
                                                    child: Text(
                                                      "See all",
                                                      style: addText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: send
                                                    .where('userSendEmail',
                                                        isEqualTo:
                                                            state.user.email)
                                                    .limit(3)
                                                    .snapshots(),
                                                builder: (_, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot.data!.docs
                                                        .isNotEmpty) {
                                                      return Column(
                                                        children:
                                                            (snapshot.data!)
                                                                .docs
                                                                .map(
                                                                  (e) => Column(
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10.h,
                                                                            horizontal: 10.w),
                                                                        width: 1
                                                                            .sw,
                                                                        height:
                                                                            70.h,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: HexColor("#9D20FF").withOpacity(0.10),
                                                                                blurRadius: 5,
                                                                                spreadRadius: 0,
                                                                                offset: Offset(2, 2),
                                                                              ),
                                                                            ]),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(15.r),
                                                                                  child: Image.network(
                                                                                    e['userTargetPhoto'],
                                                                                    width: 50.w,
                                                                                    height: 50.h,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 12.w,
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 127.w,
                                                                                      child: Text(
                                                                                        e['userTargetName'].split(' ').first,
                                                                                        style: titleName,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      formatDate(e['startTime'].toDate(), [
                                                                                        dd,
                                                                                        ' ',
                                                                                        MM,
                                                                                        ',  ',
                                                                                        HH,
                                                                                        ':',
                                                                                        nn
                                                                                      ]),
                                                                                      style: timeHome,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              "- ${convertToIdr(e['amount'])}",
                                                                              style: moneyActivityLoss,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                                .toList(),
                                                      );
                                                    } else {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 30.h,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                              child: SizedBox(
                                                                width: 120.w,
                                                                height: 36.h,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SendPage(),
                                                                        ));
                                                                  },
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            buttonMain),
                                                                  ),
                                                                  child: Text(
                                                                    'Send',
                                                                    style:
                                                                        textButton,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Text(
                                                            "Belum ada transaksi",
                                                            style:
                                                                titleElseHome,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            "Lakukan transaksi terlebih dahulu",
                                                            style:
                                                                titleSubElseHome,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  } else {
                                                    return CircularProgressIndicator();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))
                                .toList(),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CircularProgressIndicator();
            // print('INI STATENYAAAA: $state');
            // return Align(
            //   alignment: Alignment.center,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         'You are not logged in',
            //         style: GoogleFonts.poppins(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w300,
            //             color: Colors.red),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       ElevatedButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all(Colors.red),
            //         ),
            //         onPressed: () {
            //           Navigator.pushNamedAndRemoveUntil(
            //               context, '/sign-in', (route) => false);
            //         },
            //         child: Text('Login',
            //             style: GoogleFonts.poppins(color: Colors.white)),
            //       ),
            //     ],
            //   ),
            // );

          }
        },
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}
