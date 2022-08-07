import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter/services.dart';
import 'package:marcha_branch/ui/split_bill/splitBillSuccess_page.dart';

class SplitBillAdvancedPage extends StatefulWidget {
  final bool isGroup;
  final List<String> friendName;
  final List<String> friendID;
  final List<String> friendEmail;
  final List<String> friendPhoto;
  final List<String> friendDeviceToken;
  final String groupID;
  final String userName;
  final String userID;
  final String userEmail;
  final String userPhoto;
  final String note;
  final int amounts;
  final DateTime dateTime;
  const SplitBillAdvancedPage({
    Key? key,
    required this.isGroup,
    required this.friendName,
    required this.friendID,
    required this.friendEmail,
    required this.friendPhoto,
    required this.friendDeviceToken,
    required this.groupID,
    required this.userName,
    required this.userID,
    required this.userEmail,
    required this.userPhoto,
    required this.note,
    required this.amounts,
    required this.dateTime,
  }) : super(key: key);

  @override
  _SplitBillAdvancedPageState createState() => _SplitBillAdvancedPageState(
      isGroup,
      friendName,
      friendID,
      friendEmail,
      friendPhoto,
      friendDeviceToken,
      groupID,
      userName,
      userID,
      userEmail,
      userPhoto,
      note,
      amounts,
      dateTime);
}

class _SplitBillAdvancedPageState extends State<SplitBillAdvancedPage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _note = TextEditingController();
  final bool isGroup;
  final List<String> _friendName;
  final List<String> _friendID;
  final List<String> _friendEmail;
  final List<String> _friendPhoto;
  final List<String> _friendDeviceToken;
  final String _groupID;
  final String _userName;
  final String _userID;
  final String _userEmail;
  final String _userPhoto;
  final String _note;
  final int _amounts;
  final DateTime _dateTime;

  _SplitBillAdvancedPageState(
    this.isGroup,
    this._friendName,
    this._friendID,
    this._friendEmail,
    this._friendPhoto,
    this._friendDeviceToken,
    this._groupID,
    this._userName,
    this._userID,
    this._userEmail,
    this._userPhoto,
    this._note,
    this._amounts,
    this._dateTime,
  );

  final List<TextEditingController> _controllers = [];
  final List<GlobalKey<FormState>> _formKey = [];
  final List<StringBuffer> _stringBuffer = [];

  @override
  Widget build(BuildContext context) {
    int isFilled = 0;
    final divideAmount = _amounts / _friendName.length;
    // bool _statusPayment = true;
    int totalPembayaran = 0;
    for (int i = 0; i < _friendID.length; i++) {
      // _controllers
      //     .add(TextEditingController(text: divideAmount.toStringAsFixed(0)));
      _controllers.add(TextEditingController(
        text: convertToIdr(int.tryParse(divideAmount.toStringAsFixed(0))),
      ));
      _formKey.add(GlobalKey<FormState>());
      _stringBuffer.add(StringBuffer());
    }
    CollectionReference splittCollection =
        FirebaseFirestore.instance.collection('splitbill');
    final splitDoc = FirebaseFirestore.instance.collection('splitbill').doc();
    final splittID = splitDoc.id;
    final paymentCol = FirebaseFirestore.instance
        .collection('groups')
        .doc(_groupID)
        .collection('payment');
    final paymentDoc = FirebaseFirestore.instance
        .collection('groups')
        .doc(_groupID)
        .collection('payment')
        .doc();
    final paymentID = paymentDoc.id;
    // print('STATUS PAYMENT: $_statusPayment');
    return isGroup
        ?
        // Group Payment
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
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
                "Group Payment",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            "Total Payment",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            convertToIdr(_amounts),
                            // "Rp $_amounts",
                            style: inputNumber,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Status:",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'All Good',
                            style: statusSplit,
                          ),
                          // Text(
                          //   _statusPayment == 0
                          //       ? 'All Good'
                          //       : 'Something Wrong',
                          //   // "All Good",
                          //   style: statusSplit,
                          // ),
                          //atau
                          // Text("Overpayment: 30.000", style: statusSplitRed,),
                          // SizedBox(height: 5.h,),
                          // Text("120.000 - 150.000 = -30.000", style: statusSplitRedSub,),
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "Set Splitment:",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _friendID.length,
                            itemBuilder: (context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: Image.network(
                                            _friendPhoto[index],
                                            // "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg",
                                            width: 60.w,
                                            height: 60.w,
                                          )),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            _friendName[index],
                                            style: nameSplit,
                                          ),
                                          Container(
                                            width: 200.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: HexColor("#ECDAFF"),
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Form(
                                              key: _formKey[index],
                                              child: TextFormField(
                                                controller: _controllers[index],
                                                style: amountTxt,
                                                keyboardType:
                                                    TextInputType.number,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  print(value);
                                                  if (value!.isEmpty) {
                                                    return 'Amount should be filled';
                                                  } else if (value == 'Rp 0') {
                                                    return 'Amount minimum Rp 1';
                                                  } else {
                                                    return null;
                                                  }
                                                  // return value!.isEmpty || value == 'Rp 0'
                                                  //     ? 'Amount should be filled'
                                                  //     : null;
                                                },
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  CurrencyTextInputFormatter(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0,
                                                  )
                                                ],
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          HexColor('#ECDAFF'),
                                                      width: 1.w,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 85.h,
                                      ),
                                      // Text(
                                      //   _friendName[index],
                                      //   style: nameSplit,
                                      // ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 150.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
                        width: 320.w,
                        height: 60.h,
                        child: TextButton(
                          onPressed: () async {
                            for (var indexForm = 0;
                                indexForm < _friendID.length;
                                indexForm++) {
                              if (_formKey[indexForm]
                                  .currentState!
                                  .validate()) {
                                isFilled++;
                              }
                            }

                            if (isFilled == _friendID.length) {
                              for (var i = 0; i < _friendID.length; i++) {
                                var prefix =
                                    _controllers[i].text.split('Rp')[1].trim();
                                var prefix2 = prefix.split('.');
                                var concatenate = StringBuffer();

                                for (var item in prefix2) {
                                  concatenate.write(item);
                                }

                                totalPembayaran +=
                                    int.tryParse(concatenate.toString())!;
                                // totalPembayaran +=
                                //     int.tryParse(_controllers[i].text)!;
                              }
                              print('TOTAL: $totalPembayaran');
                              if (_amounts == totalPembayaran) {
                                print('MASUK TRUE');
                                await paymentDoc.set({
                                  'id': _userID,
                                  'name': _userName,
                                  'email': _userEmail,
                                  'photo': _userPhoto,
                                  'members': _friendID,
                                  'startTime': DateTime.now(),
                                  'endTime': _dateTime,
                                  'note': _note,
                                  'amount': _amounts,
                                });

                                for (var i = 0; i < _friendID.length; i++) {
                                  var prefix = _controllers[i]
                                      .text
                                      .split('Rp')[1]
                                      .trim();
                                  var prefix2 = prefix.split('.');

                                  for (var item in prefix2) {
                                    _stringBuffer[i].write(item);
                                  }
                                  print(_controllers[i].text);
                                  print(int.tryParse(
                                      _stringBuffer[i].toString()));
                                  await paymentCol
                                      .doc(paymentID)
                                      .collection('member')
                                      .doc(_friendID[i])
                                      .set({
                                    'note_return': '',
                                    'id': _friendID[i],
                                    'name': _friendName[i],
                                    'email': _friendEmail[i],
                                    'photo': _friendPhoto[i],
                                    'status': false,
                                    'statusPayment': false,
                                    'amount': int.tryParse(
                                        _stringBuffer[i].toString()),
                                  });
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplitBillSuccess(
                                        isGroup: true,
                                      ),
                                    ));
                                // setState(() {
                                //   _statusPayment = true;
                                // });
                              } else {
                                print('MASUK FALSE');

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Something wrong with amount'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: 120, right: 20, left: 20),
                                ));

                                setState(() {
                                  totalPembayaran = 0;
                                });
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text('Something Wrong'),
                                //     duration: const Duration(seconds: 2),
                                //   ),
                                // );
                                // setState(() {
                                //   _statusPayment = false;
                                // });
                              }
                              // await splitDoc.set({
                              //   'userReqID': _userID,
                              //   'userReqName': _userName,
                              //   'userReqEmail': _userEmail,
                              //   'listFriends': _friendID,
                              //   'startTime': DateTime.now(),
                              //   'endTime': 'picked',
                              //   'note': '_note.text',
                              // });

                              // for (var i = 0; i < _friendID.length; i++) {
                              //   print(_controllers[i]);
                              //   print(_controllers[i].text);
                              //   // await splittCollection
                              //   //     .doc(splittID)
                              //   //     .collection('group')
                              //   //     .doc(_friendID[i])
                              //   //     .set({
                              //   //   'note_return': '',
                              //   //   'userTargetID': _friendID[i],
                              //   //   'userTargetName': _friendName[i],
                              //   //   'userTargetEmail': _friendEmail[i],
                              //   //   'status': false,
                              //   //   'statusPayment': false,
                              //   //   'amount': _controllers[i].value,
                              //   // });
                              // }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Amount should be filled'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: 120, right: 20, left: 20),
                              ));
                              setState(() {
                                isFilled = 0;
                                // _statusPayment = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(buttonMain),
                          ),
                          child: Text(
                            'Konfirmasi',
                            style: textButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        :
        // Split Bill
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
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
                "Split Bill",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            "Total Payment",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            convertToIdr(_amounts),
                            // "Rp $_amounts",
                            style: inputNumber,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Status:",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'All Good',
                            style: statusSplit,
                          ),
                          // _statusPayment
                          //     ? Text(
                          //         'All Good',
                          //         style: statusSplit,
                          //       )
                          //     : Text(
                          //         'Something Wrong',
                          //         style: statusSplitRed,
                          //       ),

                          //atau
                          // Text("Overpayment: 30.000", style: statusSplitRed,),
                          // SizedBox(height: 5.h,),
                          // Text("120.000 - 150.000 = -30.000", style: statusSplitRedSub,),
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "Set Splitment:",
                            style: subTitleText,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _friendID.length,
                            itemBuilder: (context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: Image.network(
                                            _friendPhoto[index],
                                            // "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg",
                                            width: 60.w,
                                            height: 60.w,
                                          )),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            _friendName[index],
                                            style: nameSplit,
                                          ),
                                          Container(
                                            width: 200.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: HexColor("#ECDAFF"),
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Form(
                                              key: _formKey[index],
                                              child: TextFormField(
                                                controller: _controllers[index],
                                                style: amountTxt,
                                                keyboardType:
                                                    TextInputType.number,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  print(value);
                                                  if (value!.isEmpty) {
                                                    return 'Amount should be filled';
                                                  } else if (value == 'Rp 0') {
                                                    return 'Amount minimum Rp 1';
                                                  } else {
                                                    return null;
                                                  }
                                                  // return value!.isEmpty || value == 'Rp 0'
                                                  //     ? 'Amount should be filled'
                                                  //     : null;
                                                },
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  CurrencyTextInputFormatter(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0,
                                                  )
                                                ],
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          HexColor('#ECDAFF'),
                                                      width: 1.w,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 85.h,
                                      ),
                                      // Text(
                                      //   _friendName[index],
                                      //   style: nameSplit,
                                      // ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 150.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
                        width: 320.w,
                        height: 60.h,
                        child: TextButton(
                          onPressed: () async {
                            print('FORMKEY: ${_formKey.length}');

                            for (var indexForm = 0;
                                indexForm < _friendID.length;
                                indexForm++) {
                              if (_formKey[indexForm]
                                  .currentState!
                                  .validate()) {
                                isFilled++;
                              }
                            }

                            print('isfillednya: $isFilled');

                            if (isFilled == _friendID.length) {
                              // for (var i = 0; i < _friendID.length; i++) {
                              //   totalPembayaran +=
                              //       int.tryParse(_controllers[i].text)!;
                              // }
                              for (var i = 0; i < _friendID.length; i++) {
                                var prefix =
                                    _controllers[i].text.split('Rp')[1].trim();
                                var prefix2 = prefix.split('.');
                                var concatenate = StringBuffer();

                                for (var item in prefix2) {
                                  concatenate.write(item);
                                }

                                totalPembayaran +=
                                    int.tryParse(concatenate.toString())!;
                                print('PEMBAYARAN: $totalPembayaran');
                                // totalPembayaran +=
                                //     int.tryParse(_controllers[i].text)!;
                              }
                              print('TOTAL PEMBAYARAN: $totalPembayaran');
                              print('TOTAL AMOUNTS: $_amounts');

                              if (_amounts == totalPembayaran) {
                                print('MASUK TRUE');
                                // BENERIN
                                await splitDoc.set({
                                  'userReqID': _userID,
                                  'userReqName': _userName,
                                  'userReqEmail': _userEmail,
                                  'userReqPhoto': _userPhoto,
                                  'listFriends': _friendID,
                                  'startTime': DateTime.now(),
                                  'endTime': _dateTime,
                                  'note': _note,
                                });

                                for (var i = 0; i < _friendID.length; i++) {
                                  // print(
                                  //     'friend id length: ${_friendID.length}');
                                  print('index: $i');
                                  var prefix = _controllers[i]
                                      .text
                                      .split('Rp')[1]
                                      .trim();
                                  var prefix2 = prefix.split('.');

                                  for (var item in prefix2) {
                                    _stringBuffer[i].write(item);
                                  }
                                  print('INI ADALAH PREFIX 2');
                                  print(prefix2);
                                  print('INI ADALAH CONTROLLER I.TEXT');
                                  print(_controllers[i].text);
                                  print('INI ADALAH STRING BUFFER');
                                  print(int.tryParse(
                                      _stringBuffer[i].toString()));
                                  // BENERIN
                                  await splittCollection
                                      .doc(splittID)
                                      .collection('group')
                                      .doc(_friendID[i])
                                      .set({
                                    'note_return': '',
                                    'userTargetID': _friendID[i],
                                    'userTargetName': _friendName[i],
                                    'userTargetEmail': _friendEmail[i],
                                    'userTargetPhoto': _friendPhoto[i],
                                    'userTargetDeviceToken':
                                        _friendDeviceToken[i],
                                    'status': false,
                                    'statusPayment': false,
                                    'amount': int.tryParse(
                                        _stringBuffer[i].toString()),
                                  });
                                }
                                // BENERIN
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplitBillSuccess(
                                        isGroup: false,
                                      ),
                                    ));
                                // setState() {
                                //   _statusPayment = true;
                                // });(
                              } else {
                                print('MASUK FALSE');

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Something wrong with amount'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: 120, right: 20, left: 20),
                                ));

                                setState(() {
                                  totalPembayaran = 0;
                                  // _statusPayment = false;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Amount should be filled'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height -
                                        100,
                                    right: 20,
                                    left: 20),
                              ));
                              setState(() {
                                isFilled = 0;
                                // _statusPayment = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(buttonMain),
                          ),
                          child: Text(
                            'Konfirmasi',
                            style: textButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
