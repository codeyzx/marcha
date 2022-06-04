import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/search_page.dart';
import 'package:marcha_branch/ui/groups/group_add.dart';
import 'package:marcha_branch/ui/groups/group_otp.dart';
import 'package:marcha_branch/ui/pin/otp.dart';
import 'package:marcha_branch/ui/split_bill/split_otp.dart';

class GroupChatDetailPage extends StatefulWidget {
  final String note;
  final String groupID;
  final String docID;
  final String paymentID;
  final String userReqID;
  final DateTime endTime;
  final int amountMember;
  final int amount;
  final bool status;
  const GroupChatDetailPage({
    Key? key,
    required this.note,
    required this.groupID,
    required this.docID,
    required this.paymentID,
    required this.userReqID,
    required this.endTime,
    required this.amountMember,
    required this.amount,
    required this.status,
  }) : super(key: key);

  @override
  _GroupChatDetailPageState createState() => _GroupChatDetailPageState(
        note,
        groupID,
        docID,
        paymentID,
        userReqID,
        endTime,
        amountMember,
        amount,
        status,
      );
}

class _GroupChatDetailPageState extends State<GroupChatDetailPage> {
  final String _note;
  final String _groupID;
  final String _docID;
  final String _paymentID;
  final String _userReqID;
  final DateTime _endTime;
  final int _amountMember;
  final int _amount;
  final bool _status;

  _GroupChatDetailPageState(
    this._note,
    this._groupID,
    this._docID,
    this._paymentID,
    this._userReqID,
    this._endTime,
    this._amountMember,
    this._amount,
    this._status,
  );
  @override
  Widget build(BuildContext context) {
    CollectionReference paymentGroup = FirebaseFirestore.instance
        .collection('groups')
        .doc(_groupID)
        .collection('payment');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: HexColor('#F8F6FF'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: buttonMain,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Group Payment",
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
              return Container(
                padding: EdgeInsets.only(bottom: 70.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTabController(
                        length: 2, // length of tabs
                        initialIndex: 0,
                        child: Column(children: <Widget>[
                          TabBar(
                            labelStyle: tabTitlePayment,
                            labelColor: Colors.black,
                            unselectedLabelStyle: unTabTitlePayment,
                            unselectedLabelColor: HexColor('#9D9D9D'),
                            tabs: const [
                              Tab(text: 'Your Payment'),
                              Tab(text: 'Detail'),
                            ],
                          ),
                          Container(
                              height: 461.h, //height of TabBarView
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                              child: TabBarView(children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: users
                                        .where('email',
                                            isEqualTo: state.user.email)
                                        .snapshots(),
                                    builder: (_, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: (snapshot.data!)
                                              .docs
                                              .map((e) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                      Text(
                                                        'Your total: ',
                                                        style: labelDetGroup,
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        // 'Rp 40.000: ',
                                                        convertToIdr(
                                                            _amountMember),
                                                        style: moneyDetGroup,
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      Text(
                                                        'Note: ',
                                                        style: labelDetGroup,
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        // 'Sewa Lapang ',
                                                        _note == ''
                                                            ? 'Tidak ada catatan'
                                                            : _note,
                                                        style: noteDetGroup,
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      Text(
                                                        'Deadline: ',
                                                        style: labelDetGroup,
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        // '25 April 2022 ',
                                                        formatDate(_endTime, [
                                                          dd,
                                                          ' ',
                                                          MM,
                                                          ',  ',
                                                          // yyyy
                                                          yyyy,
                                                        ]),
                                                        style: noteDetGroup,
                                                      ),
                                                      Container(
                                                        width: 1.sw,
                                                        height: 70.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 12.h,
                                                                horizontal:
                                                                    20.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: HexColor(
                                                              '#F8F6FF'),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                            child: SizedBox(
                                                                width: 320.w,
                                                                height: 55.h,
                                                                child: _status
                                                                    ? TextButton(
                                                                        onPressed:
                                                                            () {},
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(HexColor('#9b60d6')),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Already Paid',
                                                                          style:
                                                                              textButton,
                                                                        ),
                                                                      )
                                                                    : TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          // state.user.pin == 0
                                                                          e['pin'] == 0
                                                                              ? Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Otp(isExist: false),
                                                                                  ))
                                                                              : Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => GroupOtp(pin: e['pin'], groupID: _groupID, paymentID: _paymentID, amount: _amountMember, balance: e['balance'], userReqID: _userReqID, userTargetID: e.id)
                                                                                      //     SplitOtp(
                                                                                      //   pin: state.user.pin,
                                                                                      //   userReqID: e2['userReqID'],
                                                                                      //   userTargetID: e3['userTargetID'],
                                                                                      //   amount: e3['amount'],
                                                                                      //   balance: e['balance'],
                                                                                      //   docReq: e2.id,
                                                                                      // ),
                                                                                      ),
                                                                                );
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(buttonMain),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Continue',
                                                                          style:
                                                                              textButton,
                                                                        ),
                                                                      )),
                                                          ),
                                                        ),
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
                                ),
                                ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          Text(
                                            'Total Amounts: ',
                                            style: labelDetGroup,
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            // 'Rp 120.000 ',
                                            convertToIdr(_amount),
                                            style: moneyDetGroup,
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          Text(
                                            'Payment Details: ',
                                            style: labelDetGroup,
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: paymentGroup
                                          .doc(_docID)
                                          .collection('member')
                                          .snapshots(),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                              // shrinkWrap: true,
                                              children: snapshot.data!.docs
                                                  .map((e) => Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 20.w,
                                                                  ),
                                                                  ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(10
                                                                              .r),
                                                                      child: Image
                                                                          .network(
                                                                        e['photo'],
                                                                        // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                                                        width:
                                                                            50.w,
                                                                        height:
                                                                            50.h,
                                                                      )),
                                                                  SizedBox(
                                                                    width: 15.w,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        // 'You',
                                                                        e['name'],
                                                                        style:
                                                                            noteDetGroup,
                                                                      ),
                                                                      Text(
                                                                        // 'Rp 20.000',
                                                                        convertToIdr(
                                                                            e['amount']),
                                                                        style:
                                                                            subNoteDetGroup,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  e['statusPayment']
                                                                      ? Text(
                                                                          'Already Paid',
                                                                          style:
                                                                              chatStatusGreenGroup,
                                                                        )
                                                                      : //untuk pending pake chatStatusYellowGroup
                                                                      Text(
                                                                          'Pending',
                                                                          style:
                                                                              chatStatusYellowGroup,
                                                                        ),
                                                                  SizedBox(
                                                                    width: 20.w,
                                                                  )
                                                                ],
                                                              ), //kalau already paid pake chatStatusGreenDetGroup
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 28.h,
                                                          ),
                                                        ],
                                                      ))
                                                  .toList());
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ]))
                        ])),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
