// ignore_for_file: no_logic_in_create_state

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:date_format/date_format.dart';
import 'package:marcha_branch/ui/split_bill/splitBillConfirm_page.dart';

class SplitBillDetailPage extends StatefulWidget {
  final bool isGroup;
  final List<String> friendName;
  final List<String> friendID;
  final List<String> friendEmail;
  final List<String> friendPhoto;
  final String groupID;
  final String userName;
  final String userID;
  final String userEmail;
  final String userPhoto;
  const SplitBillDetailPage({
    Key? key,
    required this.isGroup,
    required this.friendName,
    required this.friendID,
    required this.friendEmail,
    required this.friendPhoto,
    required this.groupID,
    required this.userName,
    required this.userID,
    required this.userEmail,
    required this.userPhoto,
  }) : super(key: key);

  @override
  _SplitBillDetailPageState createState() => _SplitBillDetailPageState(
        isGroup,
        friendName,
        friendID,
        friendEmail,
        friendPhoto,
        groupID,
        userName,
        userID,
        userEmail,
        userPhoto,
      );
}

class _SplitBillDetailPageState extends State<SplitBillDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final bool isGroup;
  final List<String> _friendName;
  final List<String> _friendID;
  final List<String> _friendEmail;
  final List<String> _friendPhoto;
  final String _groupID;
  final String _userName;
  final String _userID;
  final String _userEmail;
  final String _userPhoto;
  int selectedPerson = 0;
  DateTime dateTime = DateTime.now();
  _SplitBillDetailPageState(
    this.isGroup,
    this._friendName,
    this._friendID,
    this._friendEmail,
    this._friendPhoto,
    this._groupID,
    this._userName,
    this._userID,
    this._userEmail,
    this._userPhoto,
  );

  @override
  Widget build(BuildContext context) {
    return isGroup
        ?
        // Group Payment
        Scaffold(
            backgroundColor: HexColor("#F8F6FF"),
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
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Request to group member (${_friendName.length})",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 500.w,
                              height: 90.h,
                              child: ListView.builder(
                                itemCount: _friendName.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 5.h),
                                            SizedBox(
                                              width: 60.w,
                                              height: 83.h,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      child: Image.network(
                                                        _friendPhoto[index],
                                                        width: 60.w,
                                                        height: 60.h,
                                                      )),
                                                  Text(
                                                    _friendName[index],
                                                    style: nameTxt,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Text(
                        "Amount",
                        style: subTitleText,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Amount should be filled' : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyTextInputFormatter(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            )
                          ],
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: HexColor('#ECDAFF'),
                                width: 2.w,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: HexColor('#ECDAFF'),
                                width: 2.w,
                              ),
                            ),
                          ),
                          style: inputNumber,
                        ),
                      ),
                      SizedBox(
                        height: 25.5.h,
                      ),
                      Text(
                        "Note",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextField(
                        controller: _note,
                        decoration: InputDecoration(
                          hintText: 'Tambahkan Pesan',
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
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Payment Deadline",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 1.sw,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              width: 2.w, color: HexColor('#ECDAFF')),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(
                                  dateTime, [dd, ' - ', MM, ' - ', yyyy]),
                              style: hintTxt,
                            ),
                            InkWell(
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2069))
                                      .then((date) {
                                    setState(() {
                                      if (date == null) {
                                        dateTime = DateTime.now();
                                      } else {
                                        dateTime = date;
                                      }
                                    });
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/Date_range.png',
                                  width: 30.w,
                                  height: 30.h,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: SizedBox(
                            width: 320.w,
                            height: 60.h,
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var prefix =
                                      _amount.text.split('Rp')[1].trim();
                                  var prefix2 = prefix.split('.');
                                  var concatenate = StringBuffer();

                                  for (var item in prefix2) {
                                    concatenate.write(item);
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplitBillConfirmPage(
                                                friendName: _friendName,
                                                friendID: _friendID,
                                                friendEmail: _friendEmail,
                                                friendPhoto: _friendPhoto,
                                                userName: _userName,
                                                userID: _userID,
                                                userEmail: _userEmail,
                                                userPhoto: _userPhoto,
                                                note: _note.text,
                                                dateTime: dateTime,
                                                amount: int.tryParse(
                                                    concatenate.toString())!,
                                                isGroup: true,
                                                groupID: _groupID,
                                              )));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(buttonMain),
                              ),
                              child: Text(
                                'Selanjutnya',
                                style: textButton,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        :
        // Split Bill
        Scaffold(
            backgroundColor: HexColor("#F8F6FF"),
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
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Split With (${_friendName.length})",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 500.w,
                              height: 90.h,
                              child: ListView.builder(
                                itemCount: _friendName.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 5.h),
                                            SizedBox(
                                              width: 60.w,
                                              height: 83.h,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      child: Image.network(
                                                        _friendPhoto[index],
                                                        width: 60.w,
                                                        height: 60.h,
                                                      )),
                                                  Text(
                                                    _friendName[index],
                                                    style: nameTxt,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Text(
                        "Amount",
                        style: subTitleText,
                      ),

                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Amount should be filled' : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyTextInputFormatter(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            )
                          ],
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: HexColor('#ECDAFF'),
                                width: 2.w,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: HexColor('#ECDAFF'),
                                width: 2.w,
                              ),
                            ),
                          ),
                          style: inputNumber,
                        ),
                      ),
                      // TextFormField(
                      //   controller: _amount,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     CurrencyTextInputFormatter(
                      //       locale: 'id',
                      //       symbol: 'Rp ',
                      //       decimalDigits: 0,
                      //     )
                      //   ],
                      //   decoration: InputDecoration(
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: HexColor('#ECDAFF'),
                      //         width: 2.w,
                      //       ),
                      //     ),
                      //     enabledBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: HexColor('#ECDAFF'),
                      //         width: 2.w,
                      //       ),
                      //     ),
                      //   ),
                      //   style: inputNumber,
                      // ),

                      SizedBox(
                        height: 25.5.h,
                      ),
                      Text(
                        "Note",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextField(
                        controller: _note,
                        decoration: InputDecoration(
                          hintText: 'Tambahkan Pesan',
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
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Payment Deadline",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 1.sw,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              width: 2.w, color: HexColor('#ECDAFF')),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(
                                  dateTime, [dd, ' - ', MM, ' - ', yyyy]),
                              style: hintTxt,
                            ),
                            InkWell(
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2069))
                                      .then((date) {
                                    setState(() {
                                      if (date == null) {
                                        dateTime = DateTime.now();
                                      } else {
                                        dateTime = date;
                                      }
                                    });
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/Date_range.png',
                                  width: 30.w,
                                  height: 30.h,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: SizedBox(
                            width: 320.w,
                            height: 60.h,
                            child: TextButton(
                              onPressed: () {
                                print('split bill detail page');
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var prefix =
                                      _amount.text.split('Rp')[1].trim();
                                  var prefix2 = prefix.split('.');
                                  var concatenate = StringBuffer();

                                  for (var item in prefix2) {
                                    concatenate.write(item);
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplitBillConfirmPage(
                                                friendName: _friendName,
                                                friendID: _friendID,
                                                friendEmail: _friendEmail,
                                                friendPhoto: _friendPhoto,
                                                userName: _userName,
                                                userID: _userID,
                                                userEmail: _userEmail,
                                                userPhoto: _userPhoto,
                                                note: _note.text,
                                                dateTime: dateTime,
                                                amount: int.tryParse(
                                                    concatenate.toString())!,
                                                isGroup: false,
                                                groupID: _groupID,
                                              )));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(buttonMain),
                              ),
                              child: Text(
                                'Selanjutnya',
                                style: textButton,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
