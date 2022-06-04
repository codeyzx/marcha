import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/send/send_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference send = FirebaseFirestore.instance.collection('send');
    CollectionReference request =
        FirebaseFirestore.instance.collection('request');
    CollectionReference splitbill =
        FirebaseFirestore.instance.collection('splitbill');
    return Scaffold(
      backgroundColor: HexColor('#F8F6FF'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: buttonMain,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "History",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                // History Send
                StreamBuilder<QuerySnapshot>(
                  stream: send
                      .where('userSendEmail', isEqualTo: state.user.email)
                      // .orderBy('startTime', descending: false)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: (snapshot.data!)
                            .docs
                            .map(
                              (e) => Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 10.w),
                                    width: 1.sw,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: HexColor("#9D20FF")
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(2, 2),
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              //image profile
                                              child: Image.network(
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 127.w,
                                                  child: Text(
                                                    e['userTargetName'],
                                                    // "Vladimir Putin",
                                                    style: titleName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  formatDate(
                                                      e['startTime'].toDate(), [
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
                                          style: moneyActivityLoss,
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
                      return CircularProgressIndicator();
                    }
                  },
                ),

                // History User Request
                StreamBuilder<QuerySnapshot>(
                  stream: request
                      .where('userReqEmail', isEqualTo: state.user.email)
                      .where('statusPayment', isEqualTo: true)
                      // .orderBy('startTime', descending: false)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: (snapshot.data!)
                            .docs
                            .map(
                              (e) => Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 10.w),
                                    width: 1.sw,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: HexColor("#9D20FF")
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(2, 2),
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              //image profile
                                              child: Image.network(
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 127.w,
                                                  child: Text(
                                                    e['userTargetName'],
                                                    // "Vladimir Putin",
                                                    style: titleName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  formatDate(
                                                      e['startTime'].toDate(), [
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
                                          "+ ${convertToIdr(e['amount'])}",
                                          style: moneyActivity,
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
                      return CircularProgressIndicator();
                    }
                  },
                ),

                // History User Target Request
                StreamBuilder<QuerySnapshot>(
                  stream: request
                      .where('userTargetEmail', isEqualTo: state.user.email)
                      .where('statusPayment', isEqualTo: true)
                      // .orderBy('startTime', descending: false)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: (snapshot.data!)
                            .docs
                            .map(
                              (e) => Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 10.w),
                                    width: 1.sw,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: HexColor("#9D20FF")
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(2, 2),
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              //image profile
                                              child: Image.network(
                                                e['userReqPhoto'],
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 127.w,
                                                  child: Text(
                                                    e['userReqName'],
                                                    // "Vladimir Putin",
                                                    style: titleName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  formatDate(
                                                      e['startTime'].toDate(), [
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
                                          style: moneyActivityLoss,
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
                      return CircularProgressIndicator();
                    }
                  },
                ),

                // History User Request Split
                StreamBuilder<QuerySnapshot>(
                  stream: splitbill
                      .where('userReqID', isEqualTo: state.user.id)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e2) => StreamBuilder<QuerySnapshot>(
                                  stream: splitbill
                                      .doc(e2.id)
                                      .collection('group')
                                      .where('statusPayment', isEqualTo: true)
                                      .snapshots(),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: snapshot.data!.docs
                                            .map((e3) => Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                              offset:
                                                                  Offset(2, 2),
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
                                                                child: Image
                                                                    .network(
                                                                  e3['userTargetPhoto'],
                                                                  // "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                                                                  width: 50.w,
                                                                  height: 50.h,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                    width:
                                                                        127.w,
                                                                    child: Text(
                                                                      e3['userTargetName'],
                                                                      // "Vladimir Putin",
                                                                      style:
                                                                          titleName,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    formatDate(
                                                                        e2['startTime']
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
                                                                    style:
                                                                        timeHome,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            // "Rp -${e['amount']}",
                                                            "+ ${convertToIdr(e3['amount'])}",
                                                            style:
                                                                moneyActivity,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
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
                              )
                              .toList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),

                // History User Request Split
                StreamBuilder<QuerySnapshot>(
                  stream: splitbill
                      .where('listFriends', arrayContains: state.user.id)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e2) => StreamBuilder<QuerySnapshot>(
                                  stream: splitbill
                                      .doc(e2.id)
                                      .collection('group')
                                      .where('userTargetID',
                                          isEqualTo: state.user.id)
                                      .where('statusPayment', isEqualTo: true)
                                      .snapshots(),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: snapshot.data!.docs
                                            .map((e3) => Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                              offset:
                                                                  Offset(2, 2),
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
                                                                child: Image
                                                                    .network(
                                                                  e2['userReqPhoto'],
                                                                  // "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                                                                  width: 50.w,
                                                                  height: 50.h,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                    width:
                                                                        127.w,
                                                                    child: Text(
                                                                      e2['userReqName'],
                                                                      // "Vladimir Putin",
                                                                      style:
                                                                          titleName,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    formatDate(
                                                                        e2['startTime']
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
                                                                    style:
                                                                        timeHome,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            // "Rp -${e['amount']}",
                                                            "- ${convertToIdr(e3['amount'])}",
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
                              )
                              .toList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),

                SizedBox(
                  height: 30.h,
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
