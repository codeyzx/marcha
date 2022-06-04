import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/payment/payment_remind_success_page.dart';
import 'package:marcha_branch/ui/payment/payment_success_page.dart';
import 'package:marcha_branch/ui/pin/otp.dart';
import 'package:marcha_branch/ui/request/request_otp.dart';
import 'package:marcha_branch/ui/split_bill/split_otp.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference request =
        FirebaseFirestore.instance.collection('request');
    CollectionReference splitbill =
        FirebaseFirestore.instance.collection('splitbill');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: HexColor('#F8F6FF'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Payment",
            style: titleAppPayment,
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: tabTitlePayment,
            labelColor: Colors.black,
            unselectedLabelStyle: unTabTitlePayment,
            unselectedLabelColor: HexColor('#9D9D9D'),
            tabs: const [
              Tab(
                text: 'In',
              ),
              Tab(
                text: 'Out',
              )
            ],
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AuthSuccess) {
              return TabBarView(
                children: [
                  // Request IN
                  ListView(
                    shrinkWrap: true,
                    children: [
                      // Request IN - SplitBill
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.docs
                                    .map(
                                      (e) => StreamBuilder<QuerySnapshot>(
                                        stream: splitbill
                                            .where('listFriends',
                                                arrayContains: state.user.id)
                                            .snapshots(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                                children: snapshot.data!.docs
                                                    .map(
                                                      (e2) => StreamBuilder<
                                                          QuerySnapshot>(
                                                        stream: splitbill
                                                            .doc(e2.id)
                                                            .collection('group')
                                                            .where(
                                                                'userTargetID',
                                                                isEqualTo: state
                                                                    .user.id)
                                                            .where('status',
                                                                isEqualTo:
                                                                    false)
                                                            .snapshots(),
                                                        builder: (_, snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Column(
                                                              children: snapshot
                                                                  .data!.docs
                                                                  .map((e3) =>
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 20.w),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                      child: Image.network(
                                                                                        e2['userReqPhoto'],
                                                                                        // 'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                                                                                        width: 40.w,
                                                                                        height: 40.h,
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15.w,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: 160.w,
                                                                                          child: Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: FittedBox(
                                                                                              fit: BoxFit.scaleDown,
                                                                                              child: Text(
                                                                                                '${e2['userReqName']} - Group',
                                                                                                style: personPayment,
                                                                                                textAlign: TextAlign.left,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          // "Rp ${e3['amount']}",
                                                                                          convertToIdr(e3['amount']),
                                                                                          style: moneyPayment,
                                                                                        ),
                                                                                        SizedBox(
                                                                                            width: 155.w,
                                                                                            child: Text(
                                                                                              "Note : ${e2['note']}",
                                                                                              style: personPayment,
                                                                                              textAlign: TextAlign.left,
                                                                                              // overflow:
                                                                                              //     TextOverflow.ellipsis,
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Due: ${formatDate(e2['endTime'].toDate(), [
                                                                                            dd,
                                                                                            '/',
                                                                                            mm,
                                                                                            '/',
                                                                                            yy,
                                                                                          ])}",
                                                                                      style: personPayment,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5.h,
                                                                                    ),
                                                                                    // e2['status']
                                                                                    //     ? Text(
                                                                                    //         "Over Deadline",
                                                                                    //         style: statusPayment,
                                                                                    //       )
                                                                                    //     : Text(
                                                                                    //         "Pending",
                                                                                    //         style: statusPayment,
                                                                                    //       ),
                                                                                    e2['endTime'].toDate().isAfter(DateTime.now())
                                                                                        ? Text(
                                                                                            "Pending",
                                                                                            style: statusPayment,
                                                                                          )
                                                                                        : Text(
                                                                                            "Over Deadline",
                                                                                            style: statusOverPayment,
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                //button cancel
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                  child: SizedBox(
                                                                                    width: 125.w,
                                                                                    height: 38.h,
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                          context: context,
                                                                                          builder: (context) => makeDismissible(
                                                                                            child: DraggableScrollableSheet(
                                                                                                initialChildSize: 0.8,
                                                                                                builder: (_, controller) => Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: HexColor("#F6F6F6"),
                                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 11.h,
                                                                                                              ),
                                                                                                              Center(
                                                                                                                child: Container(
                                                                                                                  width: 105.w,
                                                                                                                  height: 5.h,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: HexColor('#ECDAFF'),
                                                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 40.h,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      children: [
                                                                                                                        Text(
                                                                                                                          "Reject ",
                                                                                                                          style: rejectPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "request from ",
                                                                                                                          style: personPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "${e2['userReqName']} ?",
                                                                                                                          style: NamePayment,
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      convertToIdr(e3['amount']),
                                                                                                                      // 'Rp 18.000',
                                                                                                                      style: moneyPayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 4.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      e2['note'] == '' ? 'Tidak ada catatan' : e2['note'],
                                                                                                                      // 'Makan Padang',
                                                                                                                      style: NamePayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      'Reason',
                                                                                                                      style: NamePayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    TextField(
                                                                                                                      controller: _note,
                                                                                                                      autofocus: true,
                                                                                                                      decoration: InputDecoration(
                                                                                                                        hintText: 'Tambahkan Alasan',
                                                                                                                        border: OutlineInputBorder(
                                                                                                                          borderSide: BorderSide(
                                                                                                                            color: HexColor('#ECDAFF'),
                                                                                                                            width: 2.w,
                                                                                                                          ),
                                                                                                                          borderRadius: BorderRadius.circular(10.r),
                                                                                                                        ),
                                                                                                                        enabledBorder: OutlineInputBorder(
                                                                                                                          borderSide: BorderSide(
                                                                                                                            color: HexColor('#ECDAFF'),
                                                                                                                            width: 2.w,
                                                                                                                          ),
                                                                                                                          borderRadius: BorderRadius.circular(10.r),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      style: inputNote,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.center,
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: BorderRadius.circular(8.r),
                                                                                                                    child: SizedBox(
                                                                                                                      width: 1.sw,
                                                                                                                      height: 50.h,
                                                                                                                      child: TextButton(
                                                                                                                        onPressed: () async {
                                                                                                                          await splitbill.doc(e2.id).collection('group').doc(state.user.id).update({
                                                                                                                            'status': true,
                                                                                                                            'note_return': _note.text,
                                                                                                                          });
                                                                                                                          Navigator.pop(context);
                                                                                                                        },
                                                                                                                        style: ButtonStyle(
                                                                                                                          backgroundColor: MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                                                                        ),
                                                                                                                        child: Text(
                                                                                                                          'Reject',
                                                                                                                          style: buttonPayment,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(height: 30.h),
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
                                                                                      },
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Reject',
                                                                                        style: buttonPayment,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 14.w,
                                                                                ),
                                                                                //button accept
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                  child: SizedBox(
                                                                                    width: 125.w,
                                                                                    height: 38.h,
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                          context: context,
                                                                                          builder: (context) => makeDismissible(
                                                                                            child: DraggableScrollableSheet(
                                                                                                initialChildSize: 0.4,
                                                                                                builder: (_, controller) => Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: HexColor("#F6F6F6"),
                                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 11.h,
                                                                                                              ),
                                                                                                              Center(
                                                                                                                child: Container(
                                                                                                                  width: 105.w,
                                                                                                                  height: 5.h,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: HexColor('#ECDAFF'),
                                                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 40.h,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      children: [
                                                                                                                        Text(
                                                                                                                          "Accept ",
                                                                                                                          style: AcceptPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "request from ",
                                                                                                                          style: personPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "${e2['userReqName']} ?",
                                                                                                                          // "Samuel ?",
                                                                                                                          style: NamePayment,
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      // 'Rp 18.000',
                                                                                                                      convertToIdr(e3['amount']),
                                                                                                                      style: moneyPayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 4.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      // 'Makan Padang',
                                                                                                                      e2['note'] == '' ? 'Tidak ada catatan' : e2['note'],
                                                                                                                      style: NamePayment,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.center,
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: BorderRadius.circular(8.r),
                                                                                                                    child: SizedBox(
                                                                                                                      width: 1.sw,
                                                                                                                      height: 50.h,
                                                                                                                      child: TextButton(
                                                                                                                        onPressed: () async {
                                                                                                                          e['pin'] == 0
                                                                                                                              ? Navigator.push(
                                                                                                                                  context,
                                                                                                                                  MaterialPageRoute(
                                                                                                                                    builder: (context) => Otp(isExist: false),
                                                                                                                                  ))
                                                                                                                              : Navigator.push(
                                                                                                                                  context,
                                                                                                                                  MaterialPageRoute(
                                                                                                                                    builder: (context) =>
                                                                                                                                        // Container()
                                                                                                                                        SplitOtp(
                                                                                                                                      pin: e['pin'],
                                                                                                                                      userReqID: e2['userReqID'],
                                                                                                                                      userTargetID: e3['userTargetID'],
                                                                                                                                      amount: e3['amount'],
                                                                                                                                      balance: e['balance'],
                                                                                                                                      docReq: e2.id,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                );
                                                                                                                        },
                                                                                                                        style: ButtonStyle(
                                                                                                                          backgroundColor: MaterialStateProperty.all(HexColor('#229A35')),
                                                                                                                        ),
                                                                                                                        child: Text(
                                                                                                                          'Accept',
                                                                                                                          style: buttonPayment,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(height: 30.h),
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
                                                                                      },
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all(HexColor('#229A35')),
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Accept',
                                                                                        style: buttonPayment,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                    .toList());
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
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

                      // Request IN - Request
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.docs
                                    .map(
                                      (e) => StreamBuilder<QuerySnapshot>(
                                        stream: request
                                            .where('userTargetEmail',
                                                isEqualTo: state.user.email)
                                            .where('status', isEqualTo: false)
                                            .snapshots(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                                children: snapshot.data!.docs
                                                    .map((e2) => Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20.w),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.r),
                                                                        child: Image
                                                                            .network(
                                                                          e2['userReqPhoto'],
                                                                          // 'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                                                                          width:
                                                                              40.w,
                                                                          height:
                                                                              40.h,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15.w,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                160.w,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: FittedBox(
                                                                                fit: BoxFit.scaleDown,
                                                                                child: Text(
                                                                                  '${e2['userReqName']} - Request',
                                                                                  style: personPayment,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            convertToIdr(e2['amount']),
                                                                            // "Rp ${e2['amount']}",
                                                                            style:
                                                                                moneyPayment,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 155.w,
                                                                              child: Text(
                                                                                "Note : ${e2['note']}",
                                                                                style: personPayment,
                                                                                textAlign: TextAlign.left,
                                                                                // overflow:
                                                                                //     TextOverflow.ellipsis,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "Due: ${formatDate(e2['endTime'].toDate(), [
                                                                              dd,
                                                                              '/',
                                                                              mm,
                                                                              '/',
                                                                              yy,
                                                                            ])}",
                                                                        style:
                                                                            personPayment,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5.h,
                                                                      ),
                                                                      // e2['status']
                                                                      e2['endTime']
                                                                              .toDate()
                                                                              .isAfter(DateTime.now())
                                                                          ? Text(
                                                                              "Pending",
                                                                              style: statusPayment,
                                                                            )
                                                                          : Text(
                                                                              "Over Deadline",
                                                                              style: statusOverPayment,
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  //button cancel
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          125.w,
                                                                      height:
                                                                          38.h,
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                // buildSheetReject(),
                                                                                makeDismissible(
                                                                              child: DraggableScrollableSheet(
                                                                                  initialChildSize: 0.8,
                                                                                  builder: (_, controller) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: HexColor("#F6F6F6"),
                                                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: 11.h,
                                                                                                ),
                                                                                                Center(
                                                                                                  child: Container(
                                                                                                    width: 105.w,
                                                                                                    height: 5.h,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: HexColor('#ECDAFF'),
                                                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 40.h,
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Reject ",
                                                                                                            style: rejectPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "request from ",
                                                                                                            style: personPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "${e2['userReqName']} ?",
                                                                                                            style: NamePayment,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        convertToIdr(e2['amount']),
                                                                                                        // 'Rp 18.000',
                                                                                                        style: moneyPayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 4.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        e2['note'] == '' ? 'Tidak ada catatan' : e2['note'],
                                                                                                        // 'Makan Padang',
                                                                                                        style: NamePayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        'Reason',
                                                                                                        style: NamePayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      TextField(
                                                                                                        controller: _note,
                                                                                                        autofocus: true,
                                                                                                        decoration: InputDecoration(
                                                                                                          hintText: 'Tambahkan Alasan',
                                                                                                          border: OutlineInputBorder(
                                                                                                            borderSide: BorderSide(
                                                                                                              color: HexColor('#ECDAFF'),
                                                                                                              width: 2.w,
                                                                                                            ),
                                                                                                            borderRadius: BorderRadius.circular(10.r),
                                                                                                          ),
                                                                                                          enabledBorder: OutlineInputBorder(
                                                                                                            borderSide: BorderSide(
                                                                                                              color: HexColor('#ECDAFF'),
                                                                                                              width: 2.w,
                                                                                                            ),
                                                                                                            borderRadius: BorderRadius.circular(10.r),
                                                                                                          ),
                                                                                                        ),
                                                                                                        style: inputNote,
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.center,
                                                                                                    child: ClipRRect(
                                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                                      child: SizedBox(
                                                                                                        width: 1.sw,
                                                                                                        height: 50.h,
                                                                                                        child: TextButton(
                                                                                                          onPressed: () async {
                                                                                                            await request.doc(e2.id).update({
                                                                                                              'status': true,
                                                                                                              'note_return': _note.text,
                                                                                                            });
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          style: ButtonStyle(
                                                                                                            backgroundColor: MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            'Reject',
                                                                                                            style: buttonPayment,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(height: 30.h),
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
                                                                              borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(10.r),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Reject',
                                                                          style:
                                                                              buttonPayment,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 14.w,
                                                                  ),
                                                                  //button accept
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          125.w,
                                                                      height:
                                                                          38.h,
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                // buildSheetAccept(),
                                                                                makeDismissible(
                                                                              child: DraggableScrollableSheet(
                                                                                  initialChildSize: 0.4,
                                                                                  builder: (_, controller) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: HexColor("#F6F6F6"),
                                                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: 11.h,
                                                                                                ),
                                                                                                Center(
                                                                                                  child: Container(
                                                                                                    width: 105.w,
                                                                                                    height: 5.h,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: HexColor('#ECDAFF'),
                                                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 40.h,
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Accept ",
                                                                                                            style: AcceptPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "request from ",
                                                                                                            style: personPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "${e2['userReqName']} ?",
                                                                                                            // "Samuel ?",
                                                                                                            style: NamePayment,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        // 'Rp 18.000',
                                                                                                        convertToIdr(e2['amount']),
                                                                                                        style: moneyPayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 4.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        // 'Makan Padang',
                                                                                                        e2['note'] == '' ? 'Tidak ada catatan' : e2['note'],
                                                                                                        style: NamePayment,
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.center,
                                                                                                    child: ClipRRect(
                                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                                      child: SizedBox(
                                                                                                        width: 1.sw,
                                                                                                        height: 50.h,
                                                                                                        child: TextButton(
                                                                                                          onPressed: () async {
                                                                                                            e['pin'] == 0
                                                                                                                ? Navigator.push(
                                                                                                                    context,
                                                                                                                    MaterialPageRoute(
                                                                                                                      builder: (context) => Otp(isExist: false),
                                                                                                                    ))
                                                                                                                : Navigator.push(
                                                                                                                    context,
                                                                                                                    MaterialPageRoute(
                                                                                                                      builder: (context) =>
                                                                                                                          // Container()
                                                                                                                          RequestOtp(pin: e['pin'], userReqID: e2['userReqID'], userTargetID: e2['userTargetID'], amount: e2['amount'], balance: e['balance'], docReq: e2.id),
                                                                                                                    ),
                                                                                                                  );
                                                                                                          },

                                                                                                          // onPressed: () {
                                                                                                          //   Navigator.push(
                                                                                                          //       context,
                                                                                                          //       MaterialPageRoute(
                                                                                                          //         builder: (context) => PaymentSuccessPage(),
                                                                                                          //       ));
                                                                                                          // },
                                                                                                          style: ButtonStyle(
                                                                                                            backgroundColor: MaterialStateProperty.all(HexColor('#229A35')),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            'Accept',
                                                                                                            style: buttonPayment,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(height: 30.h),
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
                                                                              borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(10.r),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(HexColor('#229A35')),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Accept',
                                                                          style:
                                                                              buttonPayment,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList());
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
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
                    ],
                  ),

                  // Request OUT
                  ListView(
                    shrinkWrap: true,
                    children: [
                      // Request OUT - SplitBill
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.docs
                                    .map(
                                      (e) => StreamBuilder<QuerySnapshot>(
                                        stream: splitbill
                                            .where('userReqID',
                                                isEqualTo: state.user.id)
                                            .snapshots(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                                children: snapshot.data!.docs
                                                    .map(
                                                      (e2) => StreamBuilder<
                                                          QuerySnapshot>(
                                                        stream: splitbill
                                                            .doc(e2.id)
                                                            .collection('group')
                                                            .where('status',
                                                                isEqualTo:
                                                                    false)
                                                            .snapshots(),
                                                        builder: (_, snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Column(
                                                              children: snapshot
                                                                  .data!.docs
                                                                  .map((e3) =>
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 20.w),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                      child: Image.network(
                                                                                        e3['userTargetPhoto'],
                                                                                        // 'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                                                                                        width: 40.w,
                                                                                        height: 40.h,
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15.w,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: 160.w,
                                                                                          child: Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: FittedBox(
                                                                                              fit: BoxFit.scaleDown,
                                                                                              child: Text(
                                                                                                'Request to ${e3['userTargetName']}',
                                                                                                style: personPayment,
                                                                                                textAlign: TextAlign.left,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          convertToIdr(e3['amount']),
                                                                                          // "Rp ${e2['amount']}",
                                                                                          style: moneyPayment,
                                                                                        ),
                                                                                        SizedBox(
                                                                                            width: 155.w,
                                                                                            child: Text(
                                                                                              "Note : ${e2['note']}",
                                                                                              style: personPayment,
                                                                                              textAlign: TextAlign.left,
                                                                                              // overflow:
                                                                                              //     TextOverflow.ellipsis,
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Due: ${formatDate(e2['endTime'].toDate(), [
                                                                                            dd,
                                                                                            '/',
                                                                                            mm,
                                                                                            '/',
                                                                                            yy,
                                                                                          ])}",
                                                                                      style: personPayment,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5.h,
                                                                                    ),
                                                                                    e2['endTime'].toDate().isAfter(DateTime.now())
                                                                                        ? Text(
                                                                                            "Pending",
                                                                                            style: statusPayment,
                                                                                          )
                                                                                        : Text(
                                                                                            "Over Deadline",
                                                                                            style: statusOverPayment,
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                //button cancel
                                                                                ClipRRect(
                                                                                  child: SizedBox(
                                                                                    width: 125.w,
                                                                                    height: 38.h,
                                                                                    child: OutlinedButton(
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                          RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10.r),
                                                                                          ),
                                                                                        ),
                                                                                        side: MaterialStateProperty.all(
                                                                                          BorderSide(
                                                                                            style: BorderStyle.solid,
                                                                                            color: buttonMain,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                          context: context,
                                                                                          builder: (context) =>
                                                                                              // buildSheetCancel(),
                                                                                              makeDismissible(
                                                                                            child: DraggableScrollableSheet(
                                                                                                initialChildSize: 0.4,
                                                                                                builder: (_, controller) => Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: HexColor("#F6F6F6"),
                                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 11.h,
                                                                                                              ),
                                                                                                              Center(
                                                                                                                child: Container(
                                                                                                                  width: 105.w,
                                                                                                                  height: 5.h,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: HexColor('#ECDAFF'),
                                                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 40.h,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      children: [
                                                                                                                        Text(
                                                                                                                          "Cancel ",
                                                                                                                          style: rejectPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "request to ",
                                                                                                                          style: personPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "${e3['userTargetName']} ?",
                                                                                                                          style: NamePayment,
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      convertToIdr(e3['amount']),
                                                                                                                      style: moneyPayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 4.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      "Note : ${e2['note']}",
                                                                                                                      style: NamePayment,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.center,
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: BorderRadius.circular(8.r),
                                                                                                                    child: SizedBox(
                                                                                                                      width: 1.sw,
                                                                                                                      height: 50.h,
                                                                                                                      child: TextButton(
                                                                                                                        onPressed: () async {
                                                                                                                          await splitbill.doc(e2.id).collection('group').doc(e3.id).update({
                                                                                                                            'status': true,
                                                                                                                            'note_return': _note.text,
                                                                                                                          });
                                                                                                                          Navigator.pop(context);
                                                                                                                        },
                                                                                                                        style: ButtonStyle(
                                                                                                                          backgroundColor: MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                                                                        ),
                                                                                                                        child: Text(
                                                                                                                          'Confirm Cancel',
                                                                                                                          style: buttonPayment,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(height: 30.h),
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
                                                                                      },
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        style: textButtonSuccess,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 14.w,
                                                                                ),
                                                                                //button remind
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                  child: SizedBox(
                                                                                    width: 125.w,
                                                                                    height: 38.h,
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                          context: context,
                                                                                          builder: (context) =>
                                                                                              // buildSheetRemind(),
                                                                                              makeDismissible(
                                                                                            child: DraggableScrollableSheet(
                                                                                                initialChildSize: 0.4,
                                                                                                builder: (_, controller) => Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: HexColor("#F6F6F6"),
                                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 11.h,
                                                                                                              ),
                                                                                                              Center(
                                                                                                                child: Container(
                                                                                                                  width: 105.w,
                                                                                                                  height: 5.h,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: HexColor('#ECDAFF'),
                                                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 40.h,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                                child: Column(
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Row(
                                                                                                                      children: [
                                                                                                                        Text(
                                                                                                                          "Give Reminder to ",
                                                                                                                          style: personPayment,
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          "${e3['userTargetName']} ?",
                                                                                                                          style: NamePayment,
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 10.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      convertToIdr(e3['amount']),
                                                                                                                      style: moneyPayment,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 4.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      e2['note'],
                                                                                                                      style: NamePayment,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                            child: Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.center,
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: BorderRadius.circular(8.r),
                                                                                                                    child: SizedBox(
                                                                                                                      width: 1.sw,
                                                                                                                      height: 50.h,
                                                                                                                      child: TextButton(
                                                                                                                        onPressed: () {
                                                                                                                          Navigator.push(
                                                                                                                              context,
                                                                                                                              MaterialPageRoute(
                                                                                                                                builder: (context) => RemindSuccessPage(),
                                                                                                                              ));
                                                                                                                        },
                                                                                                                        style: ButtonStyle(
                                                                                                                          backgroundColor: MaterialStateProperty.all(buttonMain),
                                                                                                                        ),
                                                                                                                        child: Text(
                                                                                                                          'Remind Now',
                                                                                                                          style: buttonPayment,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(height: 30.h),
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
                                                                                      },
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all(buttonMain),
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Remind',
                                                                                        style: buttonPayment,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                    .toList());
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
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

                      // Request OUT - Request
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .where('email', isEqualTo: state.user.email)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.docs
                                    .map(
                                      (e) => StreamBuilder<QuerySnapshot>(
                                        stream: request
                                            .where('userReqEmail',
                                                isEqualTo: state.user.email)
                                            .where('status', isEqualTo: false)
                                            .snapshots(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                                children: snapshot.data!.docs
                                                    .map((e2) => Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20.w),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.r),
                                                                        child: Image
                                                                            .network(
                                                                          e2['userTargetPhoto'],
                                                                          // 'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                                                                          width:
                                                                              40.w,
                                                                          height:
                                                                              40.h,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            15.w,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                160.w,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: FittedBox(
                                                                                fit: BoxFit.scaleDown,
                                                                                child: Text(
                                                                                  'Request to ${e2['userTargetName']}',
                                                                                  style: personPayment,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            convertToIdr(e2['amount']),
                                                                            // "Rp ${e2['amount']}",
                                                                            style:
                                                                                moneyPayment,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 155.w,
                                                                              child: Text(
                                                                                "Note : ${e2['note']}",
                                                                                style: personPayment,
                                                                                textAlign: TextAlign.left,
                                                                                // overflow:
                                                                                //     TextOverflow.ellipsis,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "Due: ${formatDate(e2['endTime'].toDate(), [
                                                                              dd,
                                                                              '/',
                                                                              mm,
                                                                              '/',
                                                                              yy,
                                                                            ])}",
                                                                        style:
                                                                            personPayment,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5.h,
                                                                      ),
                                                                      e2['status']
                                                                          ? Text(
                                                                              "Over Deadline",
                                                                              style: statusPayment,
                                                                            )
                                                                          : Text(
                                                                              "Pending",
                                                                              style: statusPayment,
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  //button cancel
                                                                  ClipRRect(
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          125.w,
                                                                      height:
                                                                          38.h,
                                                                      child:
                                                                          OutlinedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Colors.white),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                            ),
                                                                          ),
                                                                          side:
                                                                              MaterialStateProperty.all(
                                                                            BorderSide(
                                                                              style: BorderStyle.solid,
                                                                              color: buttonMain,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                // buildSheetCancel(),
                                                                                makeDismissible(
                                                                              child: DraggableScrollableSheet(
                                                                                  initialChildSize: 0.4,
                                                                                  builder: (_, controller) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: HexColor("#F6F6F6"),
                                                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: 11.h,
                                                                                                ),
                                                                                                Center(
                                                                                                  child: Container(
                                                                                                    width: 105.w,
                                                                                                    height: 5.h,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: HexColor('#ECDAFF'),
                                                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 40.h,
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Cancel ",
                                                                                                            style: rejectPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "request to ",
                                                                                                            style: personPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "${e2['userTargetName']} ?",
                                                                                                            style: NamePayment,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        convertToIdr(e2['amount']),
                                                                                                        style: moneyPayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 4.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        "Note : ${e2['note']}",
                                                                                                        style: NamePayment,
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.center,
                                                                                                    child: ClipRRect(
                                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                                      child: SizedBox(
                                                                                                        width: 1.sw,
                                                                                                        height: 50.h,
                                                                                                        child: TextButton(
                                                                                                          onPressed: () async {
                                                                                                            await request.doc(e2.id).update({
                                                                                                              'status': true,
                                                                                                              'note_return': _note.text,
                                                                                                            });
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          style: ButtonStyle(
                                                                                                            backgroundColor: MaterialStateProperty.all(HexColor('#DB3F3F')),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            'Confirm Cancel',
                                                                                                            style: buttonPayment,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(height: 30.h),
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
                                                                              borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(10.r),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Cancel",
                                                                          style:
                                                                              textButtonSuccess,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 14.w,
                                                                  ),
                                                                  //button remind
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          125.w,
                                                                      height:
                                                                          38.h,
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                // buildSheetRemind(),
                                                                                makeDismissible(
                                                                              child: DraggableScrollableSheet(
                                                                                  initialChildSize: 0.4,
                                                                                  builder: (_, controller) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: HexColor("#F6F6F6"),
                                                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: 11.h,
                                                                                                ),
                                                                                                Center(
                                                                                                  child: Container(
                                                                                                    width: 105.w,
                                                                                                    height: 5.h,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: HexColor('#ECDAFF'),
                                                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 40.h,
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Give Reminder to ",
                                                                                                            style: personPayment,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "${e2['userReqName']} ?",
                                                                                                            style: NamePayment,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        convertToIdr(e2['amount']),
                                                                                                        style: moneyPayment,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 4.h,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        e2['note'],
                                                                                                        style: NamePayment,
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.center,
                                                                                                    child: ClipRRect(
                                                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                                                      child: SizedBox(
                                                                                                        width: 1.sw,
                                                                                                        height: 50.h,
                                                                                                        child: TextButton(
                                                                                                          onPressed: () {
                                                                                                            Navigator.push(
                                                                                                                context,
                                                                                                                MaterialPageRoute(
                                                                                                                  builder: (context) => RemindSuccessPage(),
                                                                                                                ));
                                                                                                          },
                                                                                                          style: ButtonStyle(
                                                                                                            backgroundColor: MaterialStateProperty.all(buttonMain),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            'Remind Now',
                                                                                                            style: buttonPayment,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(height: 30.h),
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
                                                                              borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(10.r),
                                                                              ),
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
                                                                          'Remind',
                                                                          style:
                                                                              buttonPayment,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList());
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
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
                    ],
                  )

                  // ListView.builder(
                  //     physics: ScrollPhysics(),
                  //     itemCount: 5,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 20.w),
                  //         child: Column(
                  //           children: [
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.circular(8.r),
                  //                       child: Image.network(
                  //                         'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                  //                         width: 40.w,
                  //                         height: 40.h,
                  //                         fit: BoxFit.fill,
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 15.w,
                  //                     ),
                  //                     Column(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(
                  //                           width: 160.w,
                  //                           child: Align(
                  //                             alignment: Alignment.centerLeft,
                  //                             child: FittedBox(
                  //                               fit: BoxFit.scaleDown,
                  //                               child: Text(
                  //                                 'Samuel - Request',
                  //                                 style: personPayment,
                  //                                 textAlign: TextAlign.left,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "Rp 18.000",
                  //                           style: moneyPayment,
                  //                         ),
                  //                         SizedBox(
                  //                             width: 155.w,
                  //                             child: Text(
                  //                               "Note : Makan Padang",
                  //                               style: personPayment,
                  //                               textAlign: TextAlign.left,
                  //                               overflow: TextOverflow.ellipsis,
                  //                             )),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.end,
                  //                   children: [
                  //                     Text(
                  //                       "Due: 17/04/22",
                  //                       style: personPayment,
                  //                     ),
                  //                     SizedBox(
                  //                       height: 5.h,
                  //                     ),
                  //                     Text(
                  //                       "Pending",
                  //                       style: statusPayment,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               children: [
                  //                 //button cancel
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(8.r),
                  //                   child: SizedBox(
                  //                     width: 125.w,
                  //                     height: 38.h,
                  //                     child: TextButton(
                  //                       onPressed: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) => buildSheetReject(),
                  //                           isScrollControlled: true,
                  //                           backgroundColor: Colors.transparent,
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius: BorderRadius.vertical(
                  //                               top: Radius.circular(10.r),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       style: ButtonStyle(
                  //                         backgroundColor: MaterialStateProperty.all(
                  //                             HexColor('#DB3F3F')),
                  //                       ),
                  //                       child: Text(
                  //                         'Reject',
                  //                         style: buttonPayment,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   width: 14.w,
                  //                 ),
                  //                 //button accept
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(8.r),
                  //                   child: SizedBox(
                  //                     width: 125.w,
                  //                     height: 38.h,
                  //                     child: TextButton(
                  //                       onPressed: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) => buildSheetAccept(),
                  //                           isScrollControlled: true,
                  //                           backgroundColor: Colors.transparent,
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius: BorderRadius.vertical(
                  //                               top: Radius.circular(10.r),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       style: ButtonStyle(
                  //                         backgroundColor: MaterialStateProperty.all(
                  //                             HexColor('#229A35')),
                  //                       ),
                  //                       child: Text(
                  //                         'Accept',
                  //                         style: buttonPayment,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }),

                  // ListView.builder(
                  //     physics: ScrollPhysics(),
                  //     itemCount: 5,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 20.w),
                  //         child: Column(
                  //           children: [
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius:
                  //                           BorderRadius.circular(8.r),
                  //                       child: Image.network(
                  //                         'https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg',
                  //                         width: 40.w,
                  //                         height: 40.h,
                  //                         fit: BoxFit.fill,
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 15.w,
                  //                     ),
                  //                     Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(
                  //                           width: 160.w,
                  //                           child: Align(
                  //                             alignment: Alignment.centerLeft,
                  //                             child: FittedBox(
                  //                               fit: BoxFit.scaleDown,
                  //                               child: Text(
                  //                                 'Request to Samuels',
                  //                                 style: personPayment,
                  //                                 textAlign: TextAlign.left,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "Rp 18.000",
                  //                           style: moneyPayment,
                  //                         ),
                  //                         SizedBox(
                  //                             width: 155.w,
                  //                             child: Text(
                  //                               "Note : Makan Padang",
                  //                               style: personPayment,
                  //                               textAlign: TextAlign.left,
                  //                               overflow: TextOverflow.ellipsis,
                  //                             )),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.end,
                  //                   children: [
                  //                     Text(
                  //                       "Due: 17/04/22",
                  //                       style: personPayment,
                  //                     ),
                  //                     SizedBox(
                  //                       height: 5.h,
                  //                     ),
                  //                     Text(
                  //                       "Pending",
                  //                       style: statusPayment,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               children: [
                  //                 //button cancel
                  //                 ClipRRect(
                  //                   child: SizedBox(
                  //                     width: 125.w,
                  //                     height: 38.h,
                  //                     child: OutlinedButton(
                  //                       style: ButtonStyle(
                  //                         backgroundColor:
                  //                             MaterialStateProperty.all(
                  //                                 Colors.white),
                  //                         shape: MaterialStateProperty.all<
                  //                             RoundedRectangleBorder>(
                  //                           RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10.r),
                  //                           ),
                  //                         ),
                  //                         side: MaterialStateProperty.all(
                  //                           BorderSide(
                  //                             style: BorderStyle.solid,
                  //                             color: buttonMain,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       onPressed: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) =>
                  //                               buildSheetCancel(),
                  //                           isScrollControlled: true,
                  //                           backgroundColor: Colors.transparent,
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.vertical(
                  //                               top: Radius.circular(10.r),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       child: Text(
                  //                         "Cancel",
                  //                         style: textButtonSuccess,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   width: 14.w,
                  //                 ),
                  //                 //button remind
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(8.r),
                  //                   child: SizedBox(
                  //                     width: 125.w,
                  //                     height: 38.h,
                  //                     child: TextButton(
                  //                       onPressed: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) =>
                  //                               buildSheetRemind(),
                  //                           isScrollControlled: true,
                  //                           backgroundColor: Colors.transparent,
                  //                           shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.vertical(
                  //                               top: Radius.circular(10.r),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       style: ButtonStyle(
                  //                         backgroundColor:
                  //                             MaterialStateProperty.all(
                  //                                 buttonMain),
                  //                       ),
                  //                       child: Text(
                  //                         'Remind',
                  //                         style: buttonPayment,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15.h,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }),
                ],
              );
            } else {
              debugPrint('Else State Payment');
              return SizedBox();
            }
          },
        ),
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

  // Widget buildSheetReject() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.8,
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
  //                   Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 11.h,
  //                       ),
  //                       Center(
  //                         child: Container(
  //                           width: 105.w,
  //                           height: 5.h,
  //                           decoration: BoxDecoration(
  //                             color: HexColor('#ECDAFF'),
  //                             borderRadius: BorderRadius.circular(10.r),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 40.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "Reject ",
  //                                   style: rejectPayment,
  //                                 ),
  //                                 Text(
  //                                   "request from ",
  //                                   style: personPayment,
  //                                 ),
  //                                 Text(
  //                                   "Samuel ?",
  //                                   style: NamePayment,
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             Text(
  //                               'Rp 18.000',
  //                               style: moneyPayment,
  //                             ),
  //                             SizedBox(
  //                               height: 4.h,
  //                             ),
  //                             Text(
  //                               'Makan Padang',
  //                               style: NamePayment,
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             Text(
  //                               'Reason',
  //                               style: NamePayment,
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             TextField(
  //                               autofocus: true,
  //                               decoration: InputDecoration(
  //                                 hintText: 'Tambahkan Alasan',
  //                                 border: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                     color: HexColor('#ECDAFF'),
  //                                     width: 2.w,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(10.r),
  //                                 ),
  //                                 enabledBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                     color: HexColor('#ECDAFF'),
  //                                     width: 2.w,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(10.r),
  //                                 ),
  //                               ),
  //                               style: inputNote,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(8.r),
  //                             child: SizedBox(
  //                               width: 1.sw,
  //                               height: 50.h,
  //                               child: TextButton(
  //                                 onPressed: () {},
  //                                 style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       HexColor('#DB3F3F')),
  //                                 ),
  //                                 child: Text(
  //                                   'Reject',
  //                                   style: buttonPayment,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 30.h),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //   );
  // }

  // Widget buildSheetAccept() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.4,
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
  //                   Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 11.h,
  //                       ),
  //                       Center(
  //                         child: Container(
  //                           width: 105.w,
  //                           height: 5.h,
  //                           decoration: BoxDecoration(
  //                             color: HexColor('#ECDAFF'),
  //                             borderRadius: BorderRadius.circular(10.r),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 40.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "Accept ",
  //                                   style: AcceptPayment,
  //                                 ),
  //                                 Text(
  //                                   "request from ",
  //                                   style: personPayment,
  //                                 ),
  //                                 Text(
  //                                   "Samuel ?",
  //                                   style: NamePayment,
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             Text(
  //                               'Rp 18.000',
  //                               style: moneyPayment,
  //                             ),
  //                             SizedBox(
  //                               height: 4.h,
  //                             ),
  //                             Text(
  //                               'Makan Padang',
  //                               style: NamePayment,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(8.r),
  //                             child: SizedBox(
  //                               width: 1.sw,
  //                               height: 50.h,
  //                               child: TextButton(
  //                                 onPressed: () {
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             PaymentSuccessPage(),
  //                                       ));
  //                                 },
  //                                 style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       HexColor('#229A35')),
  //                                 ),
  //                                 child: Text(
  //                                   'Accept',
  //                                   style: buttonPayment,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 30.h),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //   );
  // }

  // Widget buildSheetCancel() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.4,
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
  //                   Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 11.h,
  //                       ),
  //                       Center(
  //                         child: Container(
  //                           width: 105.w,
  //                           height: 5.h,
  //                           decoration: BoxDecoration(
  //                             color: HexColor('#ECDAFF'),
  //                             borderRadius: BorderRadius.circular(10.r),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 40.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "Cancel ",
  //                                   style: rejectPayment,
  //                                 ),
  //                                 Text(
  //                                   "request to ",
  //                                   style: personPayment,
  //                                 ),
  //                                 Text(
  //                                   "Samuel ?",
  //                                   style: NamePayment,
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             Text(
  //                               'Rp 18.000',
  //                               style: moneyPayment,
  //                             ),
  //                             SizedBox(
  //                               height: 4.h,
  //                             ),
  //                             Text(
  //                               'Makan Padang',
  //                               style: NamePayment,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(8.r),
  //                             child: SizedBox(
  //                               width: 1.sw,
  //                               height: 50.h,
  //                               child: TextButton(
  //                                 onPressed: () {},
  //                                 style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       HexColor('#DB3F3F')),
  //                                 ),
  //                                 child: Text(
  //                                   'Confirm Cancel',
  //                                   style: buttonPayment,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 30.h),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //   );
  // }

  // Widget buildSheetRemind() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.4,
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
  //                   Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 11.h,
  //                       ),
  //                       Center(
  //                         child: Container(
  //                           width: 105.w,
  //                           height: 5.h,
  //                           decoration: BoxDecoration(
  //                             color: HexColor('#ECDAFF'),
  //                             borderRadius: BorderRadius.circular(10.r),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 40.h,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "Give Reminder to ",
  //                                   style: personPayment,
  //                                 ),
  //                                 Text(
  //                                   "Samuel ?",
  //                                   style: NamePayment,
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                             Text(
  //                               'Rp 18.000',
  //                               style: moneyPayment,
  //                             ),
  //                             SizedBox(
  //                               height: 4.h,
  //                             ),
  //                             Text(
  //                               'Makan Padang',
  //                               style: NamePayment,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(8.r),
  //                             child: SizedBox(
  //                               width: 1.sw,
  //                               height: 50.h,
  //                               child: TextButton(
  //                                 onPressed: () {
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             RemindSuccessPage(),
  //                                       ));
  //                                 },
  //                                 style: ButtonStyle(
  //                                   backgroundColor:
  //                                       MaterialStateProperty.all(buttonMain),
  //                                 ),
  //                                 child: Text(
  //                                   'Remind Now',
  //                                   style: buttonPayment,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 30.h),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //   );
  // }

}
