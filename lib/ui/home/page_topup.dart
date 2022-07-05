import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/api/api_base_helper.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PageTopUp extends StatefulWidget {
  const PageTopUp({Key? key}) : super(key: key);

  @override
  State<PageTopUp> createState() => _PageTopUpState();
}

class _PageTopUpState extends State<PageTopUp> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  TextEditingController email = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ApiBaseHelper api = ApiBaseHelper();
  MidtransSDK? _midtrans;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSDK();
  }

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-Jf7_deynf20wZtJq",
        merchantBaseUrl:
            "https://marcha-api-production.up.railway.app/notification_handler/",
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
      showPaymentStatus: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) async {
      print('INI RESULTNYA KOCAK');
      print(result.toJson());

      await orders.doc().set({
        "createdAt": DateTime.now(),
        "orderId": result.orderId,
        "customerId": "",
        "status": "",
        "amount": 60000,
        "items": "dummy",
      });
    });
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
          "Edit Profile",
          style: titleEdit,
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          shrinkWrap: true,
          children: [
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Nama",
                      style: labelEdit,
                    ),
                    TextFormField(
                      controller: first_name,
                      onChanged: (val) {
                        first_name.text = val;
                        first_name.selection = TextSelection.fromPosition(
                            TextPosition(offset: first_name.text.length));
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
                    Text(
                      "Last Name",
                      style: labelEdit,
                    ),
                    TextFormField(
                      controller: last_name,
                      onChanged: (val) {
                        last_name.text = val;
                        last_name.selection = TextSelection.fromPosition(
                            TextPosition(offset: last_name.text.length));
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
                    Text(
                      "Email",
                      style: labelEdit,
                    ),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (val) {
                        email.text = val;
                        email.selection = TextSelection.fromPosition(
                            TextPosition(offset: email.text.length));
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
                    Text(
                      "Phone",
                      style: labelEdit,
                    ),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (val) {
                        phone.text = val;
                        phone.selection = TextSelection.fromPosition(
                            TextPosition(offset: phone.text.length));
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

                                var orderId =
                                    DateTime.now().millisecondsSinceEpoch;

                                Map<String, dynamic> data = {
                                  "customers": {
                                    "email": email.text,
                                    "first_name": first_name.text,
                                    "last_name": last_name.text,
                                    "phone": phone.text
                                  },
                                  "items": [
                                    {
                                      "id": "item01",
                                      "price": 20000,
                                      "quantity": 3,
                                      "name": "Seblak Murah"
                                    }
                                  ],
                                  // "callbacks": {"url": "string"},
                                  "order_id": orderId.toString()
                                };

                                var body = jsonEncode(data);

                                final response = await api.post(
                                    "https://marcha-api-production.up.railway.app/charge",
                                    body);

                                await _midtrans?.startPaymentUiFlow(
                                  token: response['token'],
                                );

                                // Navigator.of(context)
                                //     .push(MaterialPageRoute<void>(
                                //         builder: (BuildContext context) {
                                //           return TopUpSaja(
                                //             token: response['token'],
                                //           );
                                //         },
                                //         fullscreenDialog: true));
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonMain),
                            ),
                            child: Text(
                              'Ubah Profile',
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
