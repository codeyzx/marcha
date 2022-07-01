import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';
import 'package:marcha_branch/ui/groups/group_page.dart';
import 'package:marcha_branch/ui/history/history_page.dart';
import 'package:marcha_branch/ui/home/notification_page.dart';
import 'package:marcha_branch/ui/home/page_topup.dart';
import 'package:marcha_branch/ui/request/request_page.dart';
import 'package:marcha_branch/ui/send/send_page.dart';
import 'package:marcha_branch/ui/split_bill/splitBill_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/virtucard/virtucard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<String> friends = [];
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference send = FirebaseFirestore.instance.collection('send');
    return Scaffold(
      backgroundColor: HexColor("#F8F6FF"),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                if (state is AuthSuccess) {
                  friends.add(state.user.email);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // State punya temen
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .doc(state.user.id)
                            .collection('friends')
                            .where('statusFriend', isEqualTo: true)
                            .where('statusRequest', isEqualTo: false)
                            // .where(
                            //     'statusRequest',
                            //     isEqualTo:
                            //         false)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            print('SNAPSHOT CENAH');
                            if (snapshot.data!.docs.isNotEmpty) {
                              var okedek = snapshot.data!.docs.length;

                              for (var i = 0; i < okedek; i++) {
                                // lee.add(snapshot.data!.docs[i]['email']);
                                friends.add(
                                    snapshot.data!.docs[i]['email'].toString());
                              }
                              // friends.add(state.user.email);
                            }
                            return SizedBox();
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      // State punya request
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .doc(state.user.id)
                            .collection('friends')
                            .where('statusFriend', isEqualTo: false)
                            .where('statusRequest', isEqualTo: true)
                            // .where(
                            //     'statusRequest',
                            //     isEqualTo:
                            //         false)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            print('SNAPSHOT CENAH');
                            if (snapshot.data!.docs.isNotEmpty) {
                              var okedek = snapshot.data!.docs.length;

                              for (var i = 0; i < okedek; i++) {
                                // lee.add(snapshot.data!.docs[i]['email']);
                                friends.add(
                                    snapshot.data!.docs[i]['email'].toString());
                              }
                              // friends.add(state.user.email);
                            }
                            return SizedBox();
                          } else {
                            return SizedBox();
                          }
                        },
                      ),

                      // Card Pengeluaran
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                width: 1.sw,
                                height: 240.h,
                                decoration: BoxDecoration(
                                  color: buttonMain,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30.r),
                                    bottomRight: Radius.circular(30.r),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/header-bg.png'),
                                  ),
                                ),
                                child: Column(
                                  children: (snapshot.data!)
                                      .docs
                                      .map((e) => Padding(
                                            padding: EdgeInsets.only(
                                                right: 17.w, left: 17.w),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 19.h),
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
                                                              // state.user.photo,
                                                              // 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Elon_Musk_2015.jpg/640px-Elon_Musk_2015.jpg',
                                                              width: 35.w,
                                                              height: 35.h,
                                                              fit: BoxFit.cover,
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
                                                              style: txtWelcome,
                                                            ),
                                                            Text(
                                                              // state.user.name,
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
                                                    convertToIdr(e['balance']),
                                                    // "Rp. " +
                                                    //     e['balance'].toString(),
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //       builder:
                                                            //           (context) =>
                                                            //               TopUpHalaman(),
                                                            //     ));
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PageTopUp()
                                                                    // DevelopmentPage(),
                                                                    ));
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
                                                                      BorderRadius
                                                                          .circular(
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
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Column(
                          children: [
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           context.read<AuthCubit>().signOut();
                            //         },
                            //         child: Text('Logout'),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 // builder: (context) => PinPage(),
                            //                 builder: (context) => FriendsPage(),
                            //                 // builder: (context) =>
                            //                 //     PinCodeVerificationScreen(),
                            //               ));
                            //         },
                            //         child: Text('Pin'),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) => PaymentPage(),
                            //               ));
                            //         },
                            //         child: Text('Payment'),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) => StatisticPage(),
                            //               ));
                            //         },
                            //         child: Text('Statistic'),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 // builder: (context) => SearchPage(),
                            //                 builder: (context) =>
                            //                     SplitBillPage(),
                            //                 // builder: (context) => GroupAdd(),
                            //                 // builder: (context) => GroupChat(),
                            //                 // builder: (context) => CreateGroupPage(),
                            //                 // builder: (context) => CreateGroupDetailPage(),
                            //                 // DynamicTextFieldView(),
                            //               ));
                            //         },
                            //         child: Text('Split Bill'),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     Expanded(
                            //       child: ElevatedButton(
                            //           onPressed: () {
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       TopUpHalaman(),
                            //                 ));
                            //           },
                            //           child: Text('Top Up')),
                            //     ),
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     Expanded(
                            //       child: ElevatedButton(
                            //           onPressed: () {
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       CreateGroupPage(),
                            //                 ));
                            //           },
                            //           child: Text('Group')),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                              height: 25.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SplitBillPage(),
                                        ));
                                    print("tapped SplitBill");
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.h,
                                        decoration: BoxDecoration(
                                          color: HexColor('#DAE2FF'),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.h,
                                        decoration: BoxDecoration(
                                          color: HexColor('#ECDAFF'),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.h,
                                        decoration: BoxDecoration(
                                          color: HexColor('#FFF2DA'),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                      builder: (context) => makeDismissible(
                                        child: DraggableScrollableSheet(
                                            initialChildSize: 0.45,
                                            builder:
                                                (_, controller) => Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            HexColor("#F6F6F6"),
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        30.r)),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        44.w),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Center(
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        105.w,
                                                                    height: 7.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: HexColor(
                                                                          '#ECDAFF'),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 18.h,
                                                                ),
                                                                Text(
                                                                  'More',
                                                                  style:
                                                                      moreTitleHome,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        18.h),
                                                                SizedBox(
                                                                  width: 1.sw,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pushReplacementNamed(
                                                                              context,
                                                                              '/split-bill');
                                                                          // Navigator.push(
                                                                          //     context,
                                                                          //     MaterialPageRoute(
                                                                          //       builder: (context) => SplitBillPage(),
                                                                          //     ));
                                                                          print(
                                                                              "tapped SplitBill");
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
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
                                                                        onTap:
                                                                            () {
                                                                          // Navigator.pushReplacementNamed(
                                                                          //     context, '/create-group');
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => GroupPage(),
                                                                              ));
                                                                          print(
                                                                              "tapped group");
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
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
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => VirtucardPage(),
                                                                              ));
                                                                          print(
                                                                              "tapped Virtucard");
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
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
                                                                SizedBox(
                                                                    height:
                                                                        24.h),
                                                                SizedBox(
                                                                  width: 162.w,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              'FRIENDS DARI HOME: $friends');
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) {
                                                                            return FriendsPage(friends: friends);
                                                                          }));
                                                                          print(
                                                                              "tapped friends");
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
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
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pushReplacementNamed(
                                                                              context,
                                                                              '/history-page');
                                                                          // Navigator.push(
                                                                          //     context,
                                                                          //     MaterialPageRoute(
                                                                          //       builder: (context) => HistoryPage(),
                                                                          //     ));
                                                                          print(
                                                                              "tapped history");
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
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
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10.r),
                                        ),
                                      ),
                                    );
                                    print("tapped more");
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.h,
                                        decoration: BoxDecoration(
                                          color: HexColor('#DAFFE0'),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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

                            //History -- List User
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          builder: (context) => HistoryPage(),
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
                            // * Last Activity
                            // ListView.builder(
                            //   physics: NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount: 5,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return Column(
                            //       children: [
                            //         Container(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 10.h, horizontal: 10.w),
                            //           width: 1.sw,
                            //           height: 70.h,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               boxShadow: [
                            //                 BoxShadow(
                            //                   color: HexColor("#9D20FF")
                            //                       .withOpacity(0.10),
                            //                   blurRadius: 5,
                            //                   spreadRadius: 0,
                            //                   offset: Offset(2, 2),
                            //                 ),
                            //               ]),
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //             children: [
                            //               Row(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   ClipRRect(
                            //                     borderRadius:
                            //                         BorderRadius.circular(15.r),
                            //                     //image profile
                            //                     child: Image.network(
                            //                       "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                            //                       width: 50.w,
                            //                       height: 50.h,
                            //                       fit: BoxFit.cover,
                            //                     ),
                            //                   ),
                            //                   SizedBox(
                            //                     width: 12.w,
                            //                   ),
                            //                   Column(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment
                            //                             .spaceBetween,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       SizedBox(
                            //                         width: 127.w,
                            //                         child: Text(
                            //                           "Vladimir Putin",
                            //                           style: titleName,
                            //                           maxLines: 1,
                            //                           overflow:
                            //                               TextOverflow.ellipsis,
                            //                         ),
                            //                       ),
                            //                       Text(
                            //                         "17 Feb, 13:30",
                            //                         style: timeHome,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //               Text(
                            //                 "+ Rp 50.000",
                            //                 style: moneyActivity,
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           height: 10.h,
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // ),

                            //* Last Activity using StreamBuilder
                            StreamBuilder<QuerySnapshot>(
                              stream: send
                                  .where('userSendEmail',
                                      isEqualTo: state.user.email)
                                  .limit(3)
                                  // .orderBy('startTime', descending: false)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    return Column(
                                      children: (snapshot.data!)
                                          .docs
                                          .map(
                                            (e) => Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.h,
                                                      horizontal: 10.w),
                                                  width: 1.sw,
                                                  height: 70.h,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: HexColor(
                                                                  "#9D20FF")
                                                              .withOpacity(
                                                                  0.10),
                                                          blurRadius: 5,
                                                          spreadRadius: 0,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ]),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.r),
                                                            //image profile
                                                            child:
                                                                Image.network(
                                                              e['userTargetPhoto'],
                                                              // "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                                                              width: 50.w,
                                                              height: 50.h,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 12.w,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 127.w,
                                                                child: Text(
                                                                  e['userTargetName'],
                                                                  // "Vladimir Putin",
                                                                  style:
                                                                      titleName,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Text(
                                                                formatDate(
                                                                    e['startTime']
                                                                        .toDate(),
                                                                    [
                                                                      dd,
                                                                      ' ',
                                                                      MM,
                                                                      ',  ',
                                                                      // yyyy
                                                                      HH,
                                                                      ':',
                                                                      nn
                                                                    ]),
                                                                // "17 Feb, 13:30",
                                                                style: timeHome,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        // "Rp -${e['amount']}",
                                                        "- ${convertToIdr(e['amount'])}",
                                                        style:
                                                            moneyActivityLoss,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            child: SizedBox(
                                              width: 120.w,
                                              height: 36.h,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SendPage(),
                                                      ));
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          buttonMain),
                                                ),
                                                child: Text(
                                                  'Send',
                                                  style: textButton,
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
                                          style: titleElseHome,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Lakukan transaksi terlebih dahulu",
                                          style: titleSubElseHome,
                                          textAlign: TextAlign.center,
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

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Last Activity',
                            //       style: subTitleFriend,
                            //     ),
                            //     TextButton(
                            //       onPressed: () {},
                            //       child: Text(
                            //         "See all",
                            //         style: addText,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 15.h,
                            // ),

                            //* Payment IN
                            // StreamBuilder<QuerySnapshot>(
                            //   stream: users
                            //       .where('email', isEqualTo: state.user.email)
                            //       .snapshots(),
                            //   builder: (_, snapshot) {
                            //     if (snapshot.hasData) {
                            //       return Column(
                            //           children: snapshot.data!.docs
                            //               .map(
                            //                 (e) => StreamBuilder<QuerySnapshot>(
                            //                   stream: request
                            //                       .where('listFriends',
                            //                           arrayContains:
                            //                               state.user.id)
                            //                       .snapshots(),
                            //                   builder: (_, snapshot) {
                            //                     if (snapshot.hasData) {
                            //                       return Column(
                            //                           children: snapshot
                            //                               .data!.docs
                            //                               .map(
                            //                                 (e2) => StreamBuilder<
                            //                                     QuerySnapshot>(
                            //                                   stream: FirebaseFirestore
                            //                                       .instance
                            //                                       .collection(
                            //                                           'request')
                            //                                       .doc(e2.id)
                            //                                       .collection(
                            //                                           'group')
                            //                                       .where(
                            //                                           'userTargetID',
                            //                                           isEqualTo:
                            //                                               state
                            //                                                   .user
                            //                                                   .id)
                            //                                       .where(
                            //                                           'status',
                            //                                           isEqualTo:
                            //                                               false)
                            //                                       .snapshots(),
                            //                                   builder: (_,
                            //                                       snapshot) {
                            //                                     if (snapshot
                            //                                         .hasData) {
                            //                                       return Column(
                            //                                         children: snapshot
                            //                                             .data!
                            //                                             .docs
                            //                                             .map(
                            //                                               (e3) =>
                            //                                                   Column(
                            //                                                 children: [
                            //                                                   Container(
                            //                                                     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                            //                                                     width: 1.sw,
                            //                                                     height: 70.h,
                            //                                                     decoration: BoxDecoration(color: Colors.white, boxShadow: [
                            //                                                       BoxShadow(
                            //                                                         color: HexColor("#9D20FF").withOpacity(0.10),
                            //                                                         blurRadius: 5,
                            //                                                         spreadRadius: 0,
                            //                                                         offset: Offset(2, 2),
                            //                                                       ),
                            //                                                     ]),
                            //                                                     child: Row(
                            //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                                                       crossAxisAlignment: CrossAxisAlignment.center,
                            //                                                       children: [
                            //                                                         Row(
                            //                                                           crossAxisAlignment: CrossAxisAlignment.center,
                            //                                                           children: [
                            //                                                             ClipRRect(
                            //                                                               borderRadius: BorderRadius.circular(15.r),
                            //                                                               //image profile
                            //                                                               child: Image.network(
                            //                                                                 // e['userReq'],
                            //                                                                 "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                            //                                                                 width: 50.w,
                            //                                                                 height: 50.h,
                            //                                                                 fit: BoxFit.cover,
                            //                                                               ),
                            //                                                             ),
                            //                                                             SizedBox(
                            //                                                               width: 12.w,
                            //                                                             ),
                            //                                                             Column(
                            //                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                                                               crossAxisAlignment: CrossAxisAlignment.start,
                            //                                                               children: [
                            //                                                                 Expanded(
                            //                                                                   child: SizedBox(
                            //                                                                     width: 127.w,
                            //                                                                     child: Text(
                            //                                                                       e2['userReqName'],
                            //                                                                       // "Vladimir Putin",
                            //                                                                       style: titleName,
                            //                                                                       maxLines: 1,
                            //                                                                       overflow: TextOverflow.ellipsis,
                            //                                                                     ),
                            //                                                                   ),
                            //                                                                 ),
                            //                                                                 Expanded(
                            //                                                                   child: Text(
                            //                                                                     e3['amount'].toString(),
                            //                                                                     style: moneyActivityLoss,
                            //                                                                   ),
                            //                                                                 ),
                            //                                                                 Expanded(
                            //                                                                   child: Text(
                            //                                                                     formatDate(e2['startTime'].toDate(), [
                            //                                                                       dd,
                            //                                                                       ' ',
                            //                                                                       MM,
                            //                                                                       ',  ',
                            //                                                                       // yyyy
                            //                                                                       HH,
                            //                                                                       ':',
                            //                                                                       nn
                            //                                                                     ]),
                            //                                                                     // "17 Feb, 13:30",
                            //                                                                     style: timeHome,
                            //                                                                   ),
                            //                                                                 ),
                            //                                                               ],
                            //                                                             ),
                            //                                                           ],
                            //                                                         ),
                            //                                                         Expanded(
                            //                                                             child: ElevatedButton(
                            //                                                                 onPressed: () {
                            //                                                                   showModalBottomSheet(
                            //                                                                     context: context,
                            //                                                                     builder: (context) => Center(
                            //                                                                       child: InkWell(
                            //                                                                         onTap: () async {
                            //                                                                           // if (e['amount'] <=
                            //                                                                           //     state
                            //                                                                           //         .user
                            //                                                                           //         .balance)
                            //                                                                           if (e3['amount'] <= e['balance']) {
                            //                                                                             print('MASUK TRUE');
                            //                                                                             print('JUMLAH AMOUNT: ${e3['amount']}');
                            //                                                                             print('JUMLAH BALANCE: ${e['balance']}');
                            //                                                                             print(e2['userReqID'].toString());

                            //                                                                             await users.doc(state.user.id).update({
                            //                                                                               'balance': FieldValue.increment(-e3['amount']),
                            //                                                                             });

                            //                                                                             await users.doc(e2['userReqID']).update({
                            //                                                                               'balance': FieldValue.increment(e3['amount']),
                            //                                                                             });

                            //                                                                             await request.doc(e2.id).collection('group').doc(state.user.id).update({
                            //                                                                               'status': true,
                            //                                                                               'statusPayment': true,
                            //                                                                             });
                            //                                                                           } else {
                            //                                                                             print('MASUK ELSE');
                            //                                                                             print('JUMLAH AMOUNT: ${e3['amount']}');
                            //                                                                             print('JUMLAH BALANCE: ${e['balance']}');
                            //                                                                             ScaffoldMessenger.of(context).showSnackBar(
                            //                                                                               const SnackBar(
                            //                                                                                 backgroundColor: Colors.red,
                            //                                                                                 content: Text('Saldo tidak mencukupi'),
                            //                                                                               ),
                            //                                                                             );
                            //                                                                           }

                            //                                                                           Navigator.pop(context);
                            //                                                                         },
                            //                                                                         child: Container(
                            //                                                                           width: 332,
                            //                                                                           height: 49,
                            //                                                                           decoration: BoxDecoration(
                            //                                                                             color: HexColor("#229A35"),
                            //                                                                             borderRadius: BorderRadius.circular(7),
                            //                                                                           ),
                            //                                                                           child: Center(
                            //                                                                             child: Text(
                            //                                                                               "Accept",
                            //                                                                               // style: GoogleFonts.poppins(
                            //                                                                               //   color: Colors.white,
                            //                                                                               //   fontSize: 14,
                            //                                                                               //   fontWeight: FontWeight.bold,
                            //                                                                               // ),
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       ),
                            //                                                                     ),
                            //                                                                   );
                            //                                                                 },
                            //                                                                 child: Text('Y'))),
                            //                                                         SizedBox(
                            //                                                           width: 10,
                            //                                                         ),
                            //                                                         Expanded(
                            //                                                             child: ElevatedButton(
                            //                                                                 onPressed: () async {
                            //                                                                   showModalBottomSheet(
                            //                                                                     context: context,
                            //                                                                     builder: (context) => Column(
                            //                                                                       mainAxisSize: MainAxisSize.min,
                            //                                                                       children: [
                            //                                                                         SizedBox(height: 41),
                            //                                                                         Center(
                            //                                                                           child: Container(
                            //                                                                             child: TextFormField(
                            //                                                                               keyboardType: TextInputType.text,
                            //                                                                               decoration: InputDecoration(labelText: 'Note *', hintText: 'Tambahkan Pesan'),
                            //                                                                               controller: _note,
                            //                                                                             ),
                            //                                                                             padding: EdgeInsets.all(30),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                         SizedBox(
                            //                                                                           height: 20,
                            //                                                                         ),
                            //                                                                         Center(
                            //                                                                           child: InkWell(
                            //                                                                             onTap: () async {
                            //                                                                               await request.doc(e2.id).collection('group').doc(state.user.id).update({
                            //                                                                                 'status': true,
                            //                                                                                 'note_return': _note.text,
                            //                                                                               });
                            //                                                                               Navigator.pop(context);
                            //                                                                             },
                            //                                                                             child: Container(
                            //                                                                               width: 332,
                            //                                                                               height: 49,
                            //                                                                               decoration: BoxDecoration(
                            //                                                                                 color: HexColor("#DB3F3F"),
                            //                                                                                 borderRadius: BorderRadius.circular(7),
                            //                                                                               ),
                            //                                                                               child: Center(
                            //                                                                                 child: Text(
                            //                                                                                   "Reject",
                            //                                                                                   // style: GoogleFonts.poppins(
                            //                                                                                   //   color: Colors.white,
                            //                                                                                   //   fontSize: 14,
                            //                                                                                   //   fontWeight: FontWeight.bold,
                            //                                                                                   // ),
                            //                                                                                 ),
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                         SizedBox(
                            //                                                                           height: 41,
                            //                                                                         ),
                            //                                                                       ],
                            //                                                                     ),
                            //                                                                   );
                            //                                                                 },
                            //                                                                 child: Text('N'))),
                            //                                                       ],
                            //                                                     ),
                            //                                                   ),
                            //                                                   SizedBox(
                            //                                                     height: 10.h,
                            //                                                   ),
                            //                                                 ],
                            //                                               ),
                            //                                             )
                            //                                             .toList(),
                            //                                       );
                            //                                     } else {
                            //                                       return Center(
                            //                                         child:
                            //                                             CircularProgressIndicator(),
                            //                                       );
                            //                                     }
                            //                                   },
                            //                                 ),
                            //                               )
                            //                               .toList());
                            //                     } else {
                            //                       return Center(
                            //                         child:
                            //                             CircularProgressIndicator(),
                            //                       );
                            //                     }
                            //                   },
                            //                 ),
                            //               )
                            //               .toList());
                            //     } else {
                            //       return Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            //   },
                            // ),

                            // REQUEST -- List User
                            // ListView(
                            //   shrinkWrap: true,
                            //   padding: const EdgeInsets.all(20),
                            //   children: [
                            //     StreamBuilder<QuerySnapshot>(
                            //       stream: users
                            //           .where('email',
                            //               isNotEqualTo: state.user.email)
                            //           .snapshots(),
                            //       builder: (_, snapshot) {
                            //         if (snapshot.hasData) {
                            //           return Column(
                            //             children: (snapshot.data!)
                            //                 .docs
                            //                 .map(
                            //                   (e) => Padding(
                            //                     padding: const EdgeInsets.only(
                            //                         bottom: 25),
                            //                     child: Row(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceBetween,
                            //                       children: [
                            //                         Column(
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .start,
                            //                           children: [
                            //                             Text(
                            //                               e['name'],
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold),
                            //                             ),
                            //                             Text(
                            //                               'Saldo: Rp. ${e['balance'].toString()}.',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w300),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         ElevatedButton(
                            //                             onPressed: () {
                            //                               Navigator.push(
                            //                                   context,
                            //                                   MaterialPageRoute(
                            //                                     builder: (context) => RequestPage(
                            //                                         // userReqID:
                            //                                         //     state.user
                            //                                         //         .id,
                            //                                         // userReqEmail:
                            //                                         //     state.user
                            //                                         //         .email,
                            //                                         // userReqName:
                            //                                         //     state.user
                            //                                         //         .name,
                            //                                         // userTargetID:
                            //                                         //     e.id,
                            //                                         // userTargetEmail: e[
                            //                                         //     'email'],
                            //                                         // userTargetName:
                            //                                         //     e['name']
                            //                                         ),
                            //                                   ));
                            //                             },
                            //                             child: Text('Request')),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 )
                            //                 .toList(),
                            //           );
                            //         } else {
                            //           return Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ],
                            // ),

                            // Payment In -- List User
                            // Padding(
                            //   padding: const EdgeInsets.all(15),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: const [
                            //       Text(
                            //         'Payment In',
                            //         style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       Text('See All')
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 30,
                            // ),
                            // ListView(
                            //   shrinkWrap: true,
                            //   padding: const EdgeInsets.all(20),
                            //   children: [
                            //     StreamBuilder<QuerySnapshot>(
                            //       stream: users
                            //           .where('email',
                            //               isEqualTo: state.user.email)
                            //           .snapshots(),
                            //       builder: (_, snapshot) {
                            //         if (snapshot.hasData) {
                            //           // print(snapshot.data!['userTargetName']);
                            //           return Column(
                            //               children: snapshot.data!.docs
                            //                   .map(
                            //                     (e) => StreamBuilder<
                            //                         QuerySnapshot>(
                            //                       stream: request
                            //                           .where('listFriends',
                            //                               arrayContains:
                            //                                   state.user.id)
                            //                           .snapshots(),
                            //                       builder: (_, snapshot) {
                            //                         if (snapshot.hasData) {
                            //                           // print(snapshot.data!['userTargetName']);
                            //                           return Column(
                            //                               children:
                            //                                   snapshot
                            //                                       .data!.docs
                            //                                       .map(
                            //                                         (e2) => StreamBuilder<
                            //                                             QuerySnapshot>(
                            //                                           stream: FirebaseFirestore
                            //                                               .instance
                            //                                               .collection(
                            //                                                   'request')
                            //                                               .doc(e2
                            //                                                   .id)
                            //                                               .collection(
                            //                                                   'group')
                            //                                               .where(
                            //                                                   'userTargetID',
                            //                                                   isEqualTo: state
                            //                                                       .user.id)
                            //                                               .where(
                            //                                                   'status',
                            //                                                   isEqualTo: false)
                            //                                               .snapshots(),
                            //                                           builder: (_,
                            //                                               snapshot) {
                            //                                             if (snapshot
                            //                                                 .hasData) {
                            //                                               return Column(
                            //                                                 children: snapshot.data!.docs
                            //                                                     .map(
                            //                                                       (e3) => Padding(
                            //                                                         padding: const EdgeInsets.only(bottom: 25),
                            //                                                         child: Row(
                            //                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                                                           children: [
                            //                                                             Column(
                            //                                                               crossAxisAlignment: CrossAxisAlignment.start,
                            //                                                               children: [
                            //                                                                 Text(
                            //                                                                   e2['userReqName'] + ' - Request',
                            //                                                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            //                                                                 ),
                            //                                                                 Text(
                            //                                                                   'Rp. ${e3['amount'].toString()}',
                            //                                                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                            //                                                                 ),
                            //                                                                 // Text(
                            //                                                                 //   'Note: ${e3['note']}',
                            //                                                                 //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                            //                                                                 // ),
                            //                                                                 // Text(
                            //                                                                 //   'Due: ${DateFormat.yMMMd('en_US').format(e3['endTime'].toDate())}',
                            //                                                                 //   // 'Due: ${DateFormat.yMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(e3['endTime']))}',
                            //                                                                 //   // 'Due: ${DateTime.fromMillisecondsSinceEpoch(int.tryParse(e3['endTime'])! * 1000)}',
                            //                                                                 //   // 'Due: ${DateTime.fromMillisecondsSinceEpoch(e3['endTime'].toDate())}',
                            //                                                                 //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                            //                                                                 // ),
                            //                                                                 Text(
                            //                                                                   'Status: ${e3['status']}',
                            //                                                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                            //                                                                 ),
                            //                                                                 ElevatedButton(
                            //                                                                     onPressed: () async {
                            //                                                                       showModalBottomSheet(
                            //                                                                         context: context,
                            //                                                                         builder: (context) => Column(
                            //                                                                           mainAxisSize: MainAxisSize.min,
                            //                                                                           children: [
                            //                                                                             SizedBox(height: 41),
                            //                                                                             Center(
                            //                                                                               child: Container(
                            //                                                                                 child: TextFormField(
                            //                                                                                   keyboardType: TextInputType.text,
                            //                                                                                   decoration: InputDecoration(labelText: 'Note *', hintText: 'Tambahkan Pesan'),
                            //                                                                                   // controller: _note,
                            //                                                                                 ),
                            //                                                                                 padding: EdgeInsets.all(30),
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                             SizedBox(
                            //                                                                               height: 20,
                            //                                                                             ),
                            //                                                                             Center(
                            //                                                                               child: InkWell(
                            //                                                                                 onTap: () async {
                            //                                                                                   await request.doc(e2.id).collection('group').doc(state.user.id).update({
                            //                                                                                     'status': true,
                            //                                                                                     // 'note_return': _note.text,
                            //                                                                                   });
                            //                                                                                   Navigator.pop(context);
                            //                                                                                 },
                            //                                                                                 child: Container(
                            //                                                                                   width: 332,
                            //                                                                                   height: 49,
                            //                                                                                   decoration: BoxDecoration(
                            //                                                                                     color: HexColor("#DB3F3F"),
                            //                                                                                     borderRadius: BorderRadius.circular(7),
                            //                                                                                   ),
                            //                                                                                   child: Center(
                            //                                                                                     child: Text(
                            //                                                                                       "Reject",
                            //                                                                                       // style: GoogleFonts.poppins(
                            //                                                                                       //   color: Colors.white,
                            //                                                                                       //   fontSize: 14,
                            //                                                                                       //   fontWeight: FontWeight.bold,
                            //                                                                                       // ),
                            //                                                                                     ),
                            //                                                                                   ),
                            //                                                                                 ),
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                             SizedBox(
                            //                                                                               height: 41,
                            //                                                                             ),
                            //                                                                           ],
                            //                                                                         ),
                            //                                                                       );
                            //                                                                     },
                            //                                                                     child: Text('Reject')),
                            //                                                                 ElevatedButton(
                            //                                                                     onPressed: () {
                            //                                                                       showModalBottomSheet(
                            //                                                                         context: context,
                            //                                                                         builder: (context) => Center(
                            //                                                                           child: InkWell(
                            //                                                                             onTap: () async {
                            //                                                                               if (e3['amount'] <= e['balance']) {
                            //                                                                                 print('MASUK TRUE');
                            //                                                                                 print('JUMLAH AMOUNT: ${e3['amount']}');
                            //                                                                                 print('JUMLAH BALANCE: ${e['balance']}');
                            //                                                                                 print(e2['userReqID'].toString());

                            //                                                                                 await users.doc(state.user.id).update({
                            //                                                                                   'balance': FieldValue.increment(-e3['amount']),
                            //                                                                                 });

                            //                                                                                 await users.doc(e2['userReqID']).update({
                            //                                                                                   'balance': FieldValue.increment(e3['amount']),
                            //                                                                                 });

                            //                                                                                 await request.doc(e2.id).collection('group').doc(state.user.id).update({
                            //                                                                                   'status': true,
                            //                                                                                   'statusPayment': true,
                            //                                                                                 });

                            //                                                                                 Navigator.push(
                            //                                                                                     context,
                            //                                                                                     MaterialPageRoute(
                            //                                                                                       builder: (context) => PaymentSuccessPage(),
                            //                                                                                     ));
                            //                                                                               } else {
                            //                                                                                 print('MASUK ELSE');
                            //                                                                                 print('JUMLAH AMOUNT: ${e3['amount']}');
                            //                                                                                 print('JUMLAH BALANCE: ${e['balance']}');
                            //                                                                                 Navigator.pop(context);
                            //                                                                                 ScaffoldMessenger.of(context).showSnackBar(
                            //                                                                                   const SnackBar(
                            //                                                                                     backgroundColor: Colors.red,
                            //                                                                                     content: Text('Saldo tidak mencukupi'),
                            //                                                                                   ),
                            //                                                                                 );
                            //                                                                               }
                            //                                                                             },
                            //                                                                             child: Container(
                            //                                                                               width: 332,
                            //                                                                               height: 49,
                            //                                                                               decoration: BoxDecoration(
                            //                                                                                 color: HexColor("#229A35"),
                            //                                                                                 borderRadius: BorderRadius.circular(7),
                            //                                                                               ),
                            //                                                                               child: Center(
                            //                                                                                 child: Text(
                            //                                                                                   "Accept",
                            //                                                                                   // style: GoogleFonts.poppins(
                            //                                                                                   //   color: Colors.white,
                            //                                                                                   //   fontSize: 14,
                            //                                                                                   //   fontWeight: FontWeight.bold,
                            //                                                                                   // ),
                            //                                                                                 ),
                            //                                                                               ),
                            //                                                                             ),
                            //                                                                           ),
                            //                                                                         ),
                            //                                                                       );
                            //                                                                     },
                            //                                                                     child: Text('Accept')),
                            //                                                               ],
                            //                                                             ),
                            //                                                           ],
                            //                                                         ),
                            //                                                       ),
                            //                                                     )
                            //                                                     .toList(),
                            //                                               );
                            //                                             } else {
                            //                                               return Center(
                            //                                                 child:
                            //                                                     CircularProgressIndicator(),
                            //                                               );
                            //                                             }
                            //                                           },
                            //                                         ),
                            //                                       )
                            //                                       .toList());
                            //                         } else {
                            //                           return Center(
                            //                             child:
                            //                                 CircularProgressIndicator(),
                            //                           );
                            //                         }
                            //                       },
                            //                     ),
                            //                   )
                            //                   .toList());
                            //         } else {
                            //           return Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ],
                            // ),

                            // Payment OUT -- List User
                            // Padding(
                            //   padding: const EdgeInsets.all(15),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         'Payment Out',
                            //         style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       Text('See All')
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 30,
                            // ),
                            // ListView(
                            //   shrinkWrap: true,
                            //   padding: const EdgeInsets.all(20),
                            //   children: [
                            //     StreamBuilder<QuerySnapshot>(
                            //       stream: requestUser
                            //           .where('status', isEqualTo: false)
                            //           .snapshots(),
                            //       builder: (_, snapshot) {
                            //         if (snapshot.hasData) {
                            //           return Column(
                            //             children: (snapshot.data!)
                            //                 .docs
                            //                 .map(
                            //                   (e) => Padding(
                            //                     padding: const EdgeInsets.only(
                            //                         bottom: 25),
                            //                     child: Row(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceBetween,
                            //                       children: [
                            //                         Column(
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .start,
                            //                           children: [
                            //                             Text(
                            //                               e['userTargetName'] +
                            //                                   ' - Request',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold),
                            //                             ),
                            //                             Text(
                            //                               'Rp. ${e['amount'].toString()}',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w300),
                            //                             ),
                            //                             Text(
                            //                               'Note: ${e['note']}',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w300),
                            //                             ),
                            //                             Text(
                            //                               'Due: ${DateFormat.yMMMd('en_US').format(e['endTime'].toDate())}',
                            //                               // 'Due: ${DateFormat.yMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(e['endTime']))}',
                            //                               // 'Due: ${DateTime.fromMillisecondsSinceEpoch(int.tryParse(e['endTime'])! * 1000)}',
                            //                               // 'Due: ${DateTime.fromMillisecondsSinceEpoch(e['endTime'].toDate())}',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w300),
                            //                             ),
                            //                             Text(
                            //                               'Status: ${e['status']}',
                            //                               style: TextStyle(
                            //                                   fontSize: 18,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w300),
                            //                             ),
                            //                             // PAYMENT OUT - REJECT
                            //                             ElevatedButton(
                            //                                 onPressed: () async {
                            //                                   showModalBottomSheet(
                            //                                     context: context,
                            //                                     builder:
                            //                                         (context) =>
                            //                                             Column(
                            //                                       mainAxisSize:
                            //                                           MainAxisSize
                            //                                               .min,
                            //                                       children: [
                            //                                         SizedBox(
                            //                                           height: 41,
                            //                                         ),
                            //                                         Center(
                            //                                           child:
                            //                                               InkWell(
                            //                                             onTap:
                            //                                                 () async {
                            //                                               await request
                            //                                                   .doc(e.id)
                            //                                                   .update({
                            //                                                 'status':
                            //                                                     true,
                            //                                                 'statusPayment':
                            //                                                     false,
                            //                                               });
                            //                                               Navigator.pop(
                            //                                                   context);
                            //                                             },
                            //                                             child:
                            //                                                 Container(
                            //                                               width:
                            //                                                   332,
                            //                                               height:
                            //                                                   49,
                            //                                               decoration:
                            //                                                   BoxDecoration(
                            //                                                 color:
                            //                                                     HexColor("#DB3F3F"),
                            //                                                 borderRadius:
                            //                                                     BorderRadius.circular(7),
                            //                                               ),
                            //                                               child:
                            //                                                   Center(
                            //                                                 child:
                            //                                                     Text(
                            //                                                   "Reject",
                            //                                                   style:
                            //                                                       GoogleFonts.poppins(
                            //                                                     color: Colors.white,
                            //                                                     fontSize: 14,
                            //                                                     fontWeight: FontWeight.bold,
                            //                                                   ),
                            //                                                 ),
                            //                                               ),
                            //                                             ),
                            //                                           ),
                            //                                         ),
                            //                                         SizedBox(
                            //                                           height: 41,
                            //                                         ),
                            //                                       ],
                            //                                     ),
                            //                                   );
                            //                                 },
                            //                                 child:
                            //                                     Text('Reject')),
                            //                             // PAYMENT OUT - REMIND
                            //                             ElevatedButton(
                            //                                 onPressed: () {
                            //                                   showModalBottomSheet(
                            //                                     context: context,
                            //                                     builder:
                            //                                         (context) =>
                            //                                             Center(
                            //                                       child: InkWell(
                            //                                         onTap:
                            //                                             () async {
                            //                                           ScaffoldMessenger.of(
                            //                                                   context)
                            //                                               .showSnackBar(
                            //                                             SnackBar(
                            //                                               backgroundColor:
                            //                                                   Colors.green,
                            //                                               content:
                            //                                                   Text('TING!! REMIND BERHASIL!!'),
                            //                                             ),
                            //                                           );
                            //                                           Navigator.pop(
                            //                                               context);
                            //                                         },
                            //                                         child:
                            //                                             Container(
                            //                                           width: 332,
                            //                                           height: 49,
                            //                                           decoration:
                            //                                               BoxDecoration(
                            //                                             color: HexColor(
                            //                                                 "#229A35"),
                            //                                             borderRadius:
                            //                                                 BorderRadius.circular(
                            //                                                     7),
                            //                                           ),
                            //                                           child:
                            //                                               Center(
                            //                                             child:
                            //                                                 Text(
                            //                                               "Remind",
                            //                                               style: GoogleFonts
                            //                                                   .poppins(
                            //                                                 color:
                            //                                                     Colors.white,
                            //                                                 fontSize:
                            //                                                     14,
                            //                                                 fontWeight:
                            //                                                     FontWeight.bold,
                            //                                               ),
                            //                                             ),
                            //                                           ),
                            //                                         ),
                            //                                       ),
                            //                                     ),
                            //                                   );
                            //                                 },
                            //                                 child:
                            //                                     Text('Remind')),
                            //                           ],
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 )
                            //                 .toList(),
                            //           );
                            //         } else {
                            //           return Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (state is AuthLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print('INI STATE: $state');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
            ],
          ),
        ],
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

  /*
  // JON
  // Widget buildSheetMore() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.45,
  //         builder: (_, controller) => Container(
  //               decoration: BoxDecoration(
  //                 color: HexColor("#F6F6F6"),
  //                 borderRadius:
  //                     BorderRadius.vertical(top: Radius.circular(30.r)),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 44.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         Center(
  //                           child: Container(
  //                             width: 105.w,
  //                             height: 7.h,
  //                             decoration: BoxDecoration(
  //                               color: HexColor('#ECDAFF'),
  //                               borderRadius: BorderRadius.circular(10.r),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 18.h,
  //                         ),
  //                         Text(
  //                           'More',
  //                           style: moreTitleHome,
  //                         ),
  //                         SizedBox(height: 18.h),
  //                         SizedBox(
  //                           width: 1.sw,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   Navigator.pushReplacementNamed(
  //                                       context, '/split-bill');
  //                                   // Navigator.push(
  //                                   //     context,
  //                                   //     MaterialPageRoute(
  //                                   //       builder: (context) => SplitBillPage(),
  //                                   //     ));
  //                                   print("tapped SplitBill");
  //                                 },
  //                                 child: Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       width: 55.w,
  //                                       height: 55.h,
  //                                       decoration: BoxDecoration(
  //                                         color: HexColor('#DAE2FF'),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.r),
  //                                       ),
  //                                       child: Center(
  //                                         child: Image.asset(
  //                                           'assets/images/icon_split.png',
  //                                           width: 30.w,
  //                                           height: 30.h,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "Split Bill",
  //                                       style: itemBlack,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               InkWell(
  //                                 onTap: () {
  //                                   // Navigator.pushReplacementNamed(
  //                                   //     context, '/create-group');
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) => GroupPage(),
  //                                       ));
  //                                   print("tapped group");
  //                                 },
  //                                 child: Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       width: 55.w,
  //                                       height: 55.h,
  //                                       decoration: BoxDecoration(
  //                                         color: HexColor('#ECDAFF'),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.r),
  //                                       ),
  //                                       child: Center(
  //                                         child: Image.asset(
  //                                           'assets/images/icon_group.png',
  //                                           width: 30.w,
  //                                           height: 30.h,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "Group",
  //                                       style: itemBlack,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               InkWell(
  //                                 onTap: () {
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) => VirtucardPage(),
  //                                       ));
  //                                   print("tapped Virtucard");
  //                                 },
  //                                 child: Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       width: 55.w,
  //                                       height: 55.h,
  //                                       decoration: BoxDecoration(
  //                                         color: HexColor('#FFF2DA'),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.r),
  //                                       ),
  //                                       child: Center(
  //                                         child: Image.asset(
  //                                           'assets/images/icon_card.png',
  //                                           width: 30.w,
  //                                           height: 30.h,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "Virtucard",
  //                                       style: itemBlack,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         SizedBox(height: 24.h),
  //                         SizedBox(
  //                           width: 162.w,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   // Navigator.pushReplacementNamed(
  //                                   //     context, '/friend-page');

  //                                   users
  //                                       .doc(state.user.id)
  //                                       .collection('friends')
  //                                       .where('statusFriend', isEqualTo: true)
  //                                       .where('statusRequest',
  //                                           isEqualTo: false)
  //                                       .snapshots()
  //                                       .listen((docSnapshot) {
  //                                     print('lah');

  //                                     docSnapshot.docs.map((e) {
  //                                       print('E NYA INI:');
  //                                       print(e['email']);
  //                                       friends.add(e['email']);
  //                                     }).toList();
  //                                     friends.add(state.user.id);

  //                                     print('kok');
  //                                   });

  //                                   Navigator.push(context,
  //                                       MaterialPageRoute(builder: (context) {
  //                                     return FriendsPage(friends: ['friends']);
  //                                   }));
  //                                   print("tapped friends");
  //                                 },
  //                                 child: Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       width: 55.w,
  //                                       height: 55.h,
  //                                       decoration: BoxDecoration(
  //                                         color: HexColor('#FADAFF'),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.r),
  //                                       ),
  //                                       child: Center(
  //                                         child: Image.asset(
  //                                           'assets/images/friend-icon.png',
  //                                           width: 30.w,
  //                                           height: 30.h,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "Friends",
  //                                       style: itemBlack,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               InkWell(
  //                                 onTap: () {
  //                                   Navigator.pushReplacementNamed(
  //                                       context, '/history-page');
  //                                   // Navigator.push(
  //                                   //     context,
  //                                   //     MaterialPageRoute(
  //                                   //       builder: (context) => HistoryPage(),
  //                                   //     ));
  //                                   print("tapped history");
  //                                 },
  //                                 child: Column(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       width: 55.w,
  //                                       height: 55.h,
  //                                       decoration: BoxDecoration(
  //                                         color: HexColor('#ECDAFF'),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.r),
  //                                       ),
  //                                       child: Center(
  //                                         child: Image.asset(
  //                                           'assets/images/history-icon.png',
  //                                           width: 30.w,
  //                                           height: 30.h,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "History",
  //                                       style: itemBlack,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //   );
  // }*/
}
