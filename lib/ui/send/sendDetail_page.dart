import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/pin/otp.dart';
import 'package:marcha_branch/ui/send/send_otp.dart';

class SendDetail extends StatefulWidget {
  final String userSendID;
  final String userSendEmail;
  final String userSendName;
  final String userSendPhoto;
  final String userTargetID;
  final String userTargetEmail;
  final String userTargetName;
  final String userTargetPhoto;
  const SendDetail({
    Key? key,
    required this.userSendID,
    required this.userSendEmail,
    required this.userSendName,
    required this.userSendPhoto,
    required this.userTargetID,
    required this.userTargetEmail,
    required this.userTargetName,
    required this.userTargetPhoto,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SendDetailState createState() => _SendDetailState(
      userSendID,
      userSendEmail,
      userSendName,
      userSendPhoto,
      userTargetID,
      userTargetEmail,
      userTargetName,
      userTargetPhoto);
}

class _SendDetailState extends State<SendDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final String _userSendID;
  final String _userSendEmail;
  final String _userSendName;
  final String _userSendPhoto;
  final String _userTargetID;
  final String _userTargetEmail;
  final String _userTargetName;
  final String _userTargetPhoto;

  _SendDetailState(
      this._userSendID,
      this._userSendEmail,
      this._userSendName,
      this._userSendPhoto,
      this._userTargetID,
      this._userTargetEmail,
      this._userTargetName,
      this._userTargetPhoto);
  @override
  Widget build(BuildContext context) {
    // CollectionReference sendCollection =
    //     FirebaseFirestore.instance.collection('send');

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: HexColor("#F8F6FF"),
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
          "Send",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 12.w, top: 20.h, right: 20.w, bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.network(
                        _userTargetPhoto,
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.contain,
                      )),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Center(
                  child: Text(
                    _userTargetName,
                    style: nameTitle,
                  ),
                ),
                Center(
                  child: Text(
                    _userTargetEmail,
                    style: usernameDet,
                  ),
                ),
                SizedBox(
                  height: 21.h,
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
                  height: 36.5.h,
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
                  height: 51.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 320.w,
                    height: 55.h,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => makeDismissible(
                              child: DraggableScrollableSheet(
                                  initialChildSize: 0.7,
                                  builder: (_, controller) => Container(
                                        decoration: BoxDecoration(
                                          color: HexColor("#F6F6F6"),
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30.r)),
                                        ),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: usersCollection
                                              .where('email',
                                                  isEqualTo: _userSendEmail)
                                              .snapshots(),
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData) {
                                              return Column(
                                                children: (snapshot.data!)
                                                    .docs
                                                    .map(
                                                      (e) => Column(
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
                                                            height: 9.h,
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
                                                                    right:
                                                                        20.w),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Send To",
                                                                  style:
                                                                      subTitle2,
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15
                                                                                .r),
                                                                        child: Image
                                                                            .network(
                                                                          _userTargetPhoto,
                                                                          width:
                                                                              60.w,
                                                                          height:
                                                                              60.h,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                                    SizedBox(
                                                                      width:
                                                                          15.w,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                245.w,
                                                                            child: Text(
                                                                              _userTargetName,
                                                                              style: titleName,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                245.w,
                                                                            child: Text(
                                                                              _userTargetEmail,
                                                                              style: username,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 25.h,
                                                                ),
                                                                Text(
                                                                  "Amount",
                                                                  style:
                                                                      subTitle2,
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    // Text(
                                                                    //   "Rp",
                                                                    //   style:
                                                                    //       amountTxt,
                                                                    // ),
                                                                    // SizedBox(
                                                                    //   width:
                                                                    //       5.w,
                                                                    // ),
                                                                    Text(
                                                                      // "300.000",
                                                                      _amount
                                                                          .text,
                                                                      style:
                                                                          amountTxt,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 25.h,
                                                                ),
                                                                Text(
                                                                  "Note",
                                                                  style:
                                                                      subTitle2,
                                                                ),
                                                                SizedBox(
                                                                  height: 5.h,
                                                                ),
                                                                Text(
                                                                  _note.text,
                                                                  style:
                                                                      noteTxt,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                ),
                                                                SizedBox(
                                                                  height: 15.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: SizedBox(
                                                              width: 320.w,
                                                              height: 55.h,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  var prefix = _amount
                                                                      .text
                                                                      .split(
                                                                          'Rp')[1]
                                                                      .trim();
                                                                  var prefix2 =
                                                                      prefix.split(
                                                                          '.');
                                                                  var concatenate =
                                                                      StringBuffer();

                                                                  for (var item
                                                                      in prefix2) {
                                                                    concatenate
                                                                        .write(
                                                                            item);
                                                                  }

                                                                  e['pin'] == 0
                                                                      ? Navigator
                                                                          .push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => Otp(isExist: false),
                                                                              ))
                                                                      : Navigator
                                                                          .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SendOtp(
                                                                              pin: e['pin'],
                                                                              userSendID: _userSendID,
                                                                              userSendEmail: _userSendEmail,
                                                                              userSendName: _userSendName,
                                                                              userSendPhoto: _userSendPhoto,
                                                                              userTargetID: _userTargetID,
                                                                              userTargetEmail: _userTargetEmail,
                                                                              userTargetName: _userTargetName,
                                                                              userTargetPhoto: _userTargetPhoto,
                                                                              amount: int.tryParse(concatenate.toString())!,
                                                                              note: _note.text,
                                                                              balance: e['balance'],
                                                                            ),
                                                                          ),
                                                                        );
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                              buttonMain),
                                                                ),
                                                                child: Text(
                                                                  'Konfirmasi',
                                                                  style:
                                                                      textButton,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
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
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonMain),
                      ),
                      child: Text(
                        'Selanjutnya',
                        style: textButton,
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

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}
