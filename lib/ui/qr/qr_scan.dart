import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/qr/qr_page.dart';
import 'package:marcha_branch/ui/request/request_detail_page.dart';
import 'package:marcha_branch/ui/send/sendDetail_page.dart';
import 'package:marcha_branch/ui/send/send_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScan extends StatefulWidget {
  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool canShowQRScanner = false;

  @override
  void initState() {
    getCameraPermission();
    super.initState();
  }

  void getCameraPermission() async {
    print(await Permission.camera.status);
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          canShowQRScanner = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Tolong izinin kami untuk akses kamera kamu agar bisa menggunakan fitur ini yaa :)',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        canShowQRScanner = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(body: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AuthSuccess) {
          return Stack(
            alignment: Alignment.center,
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: (QRViewController controller) {
                  controller.scannedDataStream.listen((barcode) => setState(() {
                        controller.pauseCamera();
                        HapticFeedback.vibrate();

                        showModalBottomSheet(
                          context: context,
                          builder: (context) => makeDismissible(
                            child: DraggableScrollableSheet(
                                initialChildSize: 0.4,
                                builder: (_, controller) => Container(
                                      decoration: BoxDecoration(
                                        color: buttonMain,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30.r)),
                                      ),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: users
                                            .where('email',
                                                isEqualTo: barcode.code)
                                            .snapshots(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.docs.isEmpty) {
                                              print(
                                                  'IS EMPTY: ${snapshot.data!.docs.isEmpty}');
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Center(
                                                          child: Container(
                                                        width: 105.w,
                                                        height: 5.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: HexColor(
                                                              "#ECDAFF"),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                      )),
                                                      SizedBox(
                                                        height: 34.h,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20.w,
                                                                  right: 20.w),
                                                          child: Text(
                                                            'User Tidak Ditemukan',
                                                            style: notFoundScan,
                                                          )),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20.w,
                                                                  right: 20.w),
                                                          child: Text(
                                                            'Sepertinya QR Code yang kamu scan salah...',
                                                            style:
                                                                notFoundSubScan,
                                                          )),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: ClipRRect(
                                                          child: SizedBox(
                                                            width: 320.w,
                                                            height: 55.h,
                                                            child:
                                                                OutlinedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        HexColor(
                                                                            '#6F1BC6')),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                ),
                                                                side:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  BorderSide(
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // Navigator.pushReplacement(
                                                                //     context,
                                                                //     MaterialPageRoute(
                                                                //       builder: (context) =>
                                                                //           BotNavBar(),
                                                                //     ));
                                                                Navigator
                                                                    .pushReplacementNamed(
                                                                        context,
                                                                        '/nav-bar');
                                                              },
                                                              child: Text(
                                                                "Kembali",
                                                                style:
                                                                    textButton,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            } else {
                                              print(
                                                  'IS NOT EMPTY: ${snapshot.data!.docs.isEmpty}');
                                              return Column(
                                                children: (snapshot.data!)
                                                    .docs
                                                    .map((e) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Center(
                                                          child: Container(
                                                        width: 105.w,
                                                        height: 5.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: HexColor(
                                                              "#ECDAFF"),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                      )),
                                                      SizedBox(
                                                        height: 23.h,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.w,
                                                                right: 20.w),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(15
                                                                            .r),
                                                                    child: Image
                                                                        .network(
                                                                      // "https://www.diethelmtravel.com/wp-content/uploads/2016/04/bill-gates-wealthiest-person.jpg",
                                                                      e['photo'],
                                                                      width:
                                                                          60.w,
                                                                      height:
                                                                          60.h,
                                                                    )),
                                                                SizedBox(
                                                                  width: 15.w,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        width: 245
                                                                            .w,
                                                                        child:
                                                                            Text(
                                                                          // "Ahmad Joni Subagja Bang Jago Top Frag",
                                                                          e['name'],
                                                                          style:
                                                                              nameScan,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        )),
                                                                    Container(
                                                                        width: 245
                                                                            .w,
                                                                        child:
                                                                            Text(
                                                                          // "@ahmadjoni",
                                                                          e['email'],
                                                                          style:
                                                                              usernameScan,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 23.h,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      ClipRRect(
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          150.w,
                                                                      height:
                                                                          40.h,
                                                                      child:
                                                                          OutlinedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(HexColor('#6F1BC6')),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.r),
                                                                            ),
                                                                          ),
                                                                          side:
                                                                              MaterialStateProperty.all(
                                                                            BorderSide(
                                                                              style: BorderStyle.solid,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => SendDetail(userSendID: state.user.id, userSendEmail: state.user.email, userSendName: state.user.name, userSendPhoto: state.user.photo, userTargetID: e.id, userTargetEmail: e['email'], userTargetName: e['name'], userTargetPhoto: e['photo'])));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Send",
                                                                          style:
                                                                              textButton,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      ClipRRect(
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          150.w,
                                                                      height:
                                                                          40.h,
                                                                      child:
                                                                          OutlinedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(HexColor('#6F1BC6')),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.r),
                                                                            ),
                                                                          ),
                                                                          side:
                                                                              MaterialStateProperty.all(
                                                                            BorderSide(
                                                                              style: BorderStyle.solid,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => RequestDetail(
                                                                                  userReqID: state.user.id,
                                                                                  userReqEmail: state.user.email,
                                                                                  userReqName: state.user.name,
                                                                                  userReqPhoto: state.user.photo,
                                                                                  userTargetID: e.id,
                                                                                  userTargetEmail: e['email'],
                                                                                  userTargetName: e['name'],
                                                                                  userTargetPhoto: e['photo'],
                                                                                ),
                                                                              ));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Request",
                                                                          style:
                                                                              textButton,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: ClipRRect(
                                                                child: SizedBox(
                                                                  width: 1.sw,
                                                                  height: 40.h,
                                                                  child:
                                                                      OutlinedButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              HexColor('#6F1BC6')),
                                                                      shape: MaterialStateProperty
                                                                          .all<
                                                                              RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.r),
                                                                        ),
                                                                      ),
                                                                      side: MaterialStateProperty
                                                                          .all(
                                                                        BorderSide(
                                                                          style:
                                                                              BorderStyle.solid,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Success to add ${e['name']}",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                      await users
                                                                          .doc(state
                                                                              .user
                                                                              .id)
                                                                          .collection(
                                                                              'friends')
                                                                          .doc(e
                                                                              .id)
                                                                          .set({
                                                                        'name':
                                                                            e['name'],
                                                                        'email':
                                                                            e['email'],
                                                                        'photo':
                                                                            e['photo'],
                                                                        'isRequest':
                                                                            true,
                                                                        'statusRequest':
                                                                            true,
                                                                        'statusFriend':
                                                                            false,
                                                                      });

                                                                      await users
                                                                          .doc(e
                                                                              .id)
                                                                          .collection(
                                                                              'friends')
                                                                          .doc(state
                                                                              .user
                                                                              .id)
                                                                          .set({
                                                                        'name': state
                                                                            .user
                                                                            .name,
                                                                        'email': state
                                                                            .user
                                                                            .email,
                                                                        'photo': state
                                                                            .user
                                                                            .photo,
                                                                        'isRequest':
                                                                            false,
                                                                        'statusRequest':
                                                                            true,
                                                                        'statusFriend':
                                                                            false,
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "Add Friend",
                                                                      style:
                                                                          textButton,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                            }
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
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
                      }));
                },
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              Padding(
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.only(bottom: 40.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      width: 300.w,
                      height: 50.h,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrPage(),
                              ));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(HexColor('#FFFFFF')),
                        ),
                        child: Text(
                          'My Qr Code',
                          style: TextStyle(color: HexColor('#8C3FDB')),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    ));
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
