import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/api/api_base_helper.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class TopUpPage extends StatefulWidget {
  final String uid;
  final String email;
  final String name;
  const TopUpPage(
      {Key? key, required this.uid, required this.email, required this.name})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
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

  ApiBaseHelper api = ApiBaseHelper();
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
        clientKey: "SB-Mid-client-Jf7_deynf20wZtJq",
        merchantBaseUrl:
            "https://marcha-api-production.up.railway.app/notification_handler/",
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
        elevation: 0,
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
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History Top Up',
                    style: subTitleFriend,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => HistoryPage(),
                      //     ));
                    },
                    child: Text(
                      "See all",
                      style: addText,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: orders.where('customerId', isEqualTo: _uid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: (snapshot.data!)
                        .docs
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              width: 1.sw,
                              height: 80.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          HexColor("#9D20FF").withOpacity(0.10),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                      offset: Offset(2, 2),
                                    ),
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(
                                          //   width: 127.w,
                                          //   child: Text(
                                          //     e['orderId'],
                                          //     style: GoogleFonts.poppins(
                                          //       fontSize: 13,
                                          //     ),
                                          //   ),
                                          // ),
                                          Text(e['items']),
                                          Text(
                                              'Method Payment : ${e['methodPayment']}'),

                                          e['token'] == ''
                                              ? SizedBox()
                                              : Text('Token : ${e['token']}'),
                                          Text(
                                            formatDate(
                                                e['createdAt'].toDate(), [
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
                                      e['status'] == 'settlement'
                                          ? 'Berhasil'
                                          : e['status'] == 'failure'
                                              ? 'Gagal'
                                              : e['status'] == 'pending'
                                                  ? 'Menunggu'
                                                  : e['status'],
                                      style: e['status'] == 'settlement'
                                          ? moneyActivity
                                          : e['status'] == 'failure'
                                              ? moneyActivityLoss
                                              : e['status'] == 'pending'
                                                  ? moneyActivityPending
                                                  : moneyActivity),
                                  e['status'] == 'settlement'
                                      ? Text(
                                          // "Rp -${e['amount']}",
                                          "+ ${convertToIdr(e['amount'])}",
                                          style: moneyActivity,
                                        )
                                      : SizedBox()
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
            SizedBox(
              height: 24.h,
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
                        print(value);
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
                                  // "callbacks": {"url": "string"},
                                  "order_id": orderId.toString()
                                };

                                var body = jsonEncode(data);

                                final response = await api.post(
                                    "https://marcha-api-production.up.railway.app/charge",
                                    body);

                                print('RESPONSE DARI TOPUP PAGE: $response');
                                print('RESPONSE TOKEN: ${response['token']}');

                                await _midtrans?.startPaymentUiFlow(
                                  token: response['token'],
                                );
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
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
