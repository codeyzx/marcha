import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/home/history_topup_page.dart';
import 'package:marcha_branch/ui/home/topup_detail_page.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class TopUpPage extends StatefulWidget {
  final String uid;
  final String email;
  final String name;
  const TopUpPage(
      {Key? key, required this.uid, required this.email, required this.name})
      : super(key: key);

  @override
  State<TopUpPage> createState() => _TopUpPageState(uid, email, name);
}

class _TopUpPageState extends State<TopUpPage> {
  final String _uid;
  final String _email;
  final String _name;

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController amount = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Dio _dio = Dio();
  MidtransSDK? _midtrans;

  _TopUpPageState(this._uid, this._email, this._name);

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  void initSDK() async {
    print('initsdk');

    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-Kiq46NFK_4Ma37kS",
        merchantBaseUrl:
            "https://marcha-backend.herokuapp.com/notification_handler/",
      ),
    );
    print('midtranssdk.init');
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
      showPaymentStatus: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) async {
      if (!result.isTransactionCanceled) {
        var prefix = amount.text.split('Rp')[1].trim();
        var prefix2 = prefix.split('.');
        var concatenate = StringBuffer();

        for (var item in prefix2) {
          concatenate.write(item);
        }

        await orders.doc().set({
          "createdAt": DateTime.now(),
          "orderId": result.orderId,
          "methodPayment": '',
          "token": "",
          "customerId": _uid,
          "status": "",
          "amount": int.tryParse(concatenate.toString()),
          "items": amount.text,
        });

        // Navigator.pushReplacementNamed(context, '/nav-bar');
      }
    });

    print('init ended');
  }

  Future<Response> getMidtransToken(String body) async {
    try {
      final response = await _dio.post(
        'https://marcha-backend.herokuapp.com/charge',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Top Up",
          style: titleEdit,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jumlah Top Up",
                      style: labelEdit,
                    ),
                    TextFormField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        )
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Amount should be filled';
                        } else if (value == 'Rp 0') {
                          return 'Amount minimum Rp 1';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#E5E5E5'),
                            width: 1.w,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#E5E5E5'),
                            width: 1.w,
                          ),
                        ),
                      ),
                      style: inputEdit,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: SizedBox(
                          width: 1.sw,
                          height: 55.h,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                var prefix = amount.text.split('Rp')[1].trim();
                                var prefix2 = prefix.split('.');
                                var concatenate = StringBuffer();

                                for (var item in prefix2) {
                                  concatenate.write(item);
                                }

                                var orderId =
                                    DateTime.now().millisecondsSinceEpoch;

                                Map<String, dynamic> data = {
                                  "customers": {
                                    "email": _email,
                                    "first_name": _name,
                                    "last_name": '',
                                    "phone": 'phone.text'
                                  },
                                  "items": [
                                    {
                                      "id": "topupcustom",
                                      "price":
                                          int.tryParse(concatenate.toString()),
                                      "quantity": 1,
                                      "name": amount.text
                                    }
                                  ],
                                  "order_id": orderId.toString()
                                };

                                var body = jsonEncode(data);
                                print(body);
                                final response = await getMidtransToken(body);

                                if (response.statusCode == 200) {
                                  await _midtrans?.startPaymentUiFlow(
                                    token: response.data['token'].toString(),
                                  );
                                } else {
                                  print('gagal');
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonMain),
                            ),
                            child: Text(
                              'Top Up',
                              style: textButton,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History Top Up',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HistoryTopUpPage(uid: _uid)));
                    },
                    child: Text(
                      "See all",
                      style: GoogleFonts.poppins(
                        color: buttonMain,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: orders
                  .where('customerId', isEqualTo: _uid)
                  .limit(5)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: (snapshot.data!)
                        .docs
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              bottom: 20.h,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopUpDetailPage(
                                            items: e['items'],
                                            merchant: e['methodPayment']
                                                .toUpperCase(),
                                            status: e['status'],
                                            orderId: e['orderId'],
                                            docsId: e.id)));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e['methodPayment'].toUpperCase(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        topUpName(e['status']),
                                        style: statusTopUp(e['status']),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        formatDate(e['createdAt'].toDate(),
                                            [dd, ' ', MM, ',  ', HH, ':', nn]),
                                        style: timeHome,
                                      ),
                                      Text(
                                        e['items'],
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.8,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
