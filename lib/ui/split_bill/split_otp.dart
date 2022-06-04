import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/ui/payment/payment_success_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SplitOtp extends StatefulWidget {
  final int pin;
  final String docReq;
  final int amount;
  final int balance;
  final String userReqID;
  final String userTargetID;
  const SplitOtp({
    Key? key,
    required this.pin,
    required this.docReq,
    required this.amount,
    required this.balance,
    required this.userReqID,
    required this.userTargetID,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SplitOtpState createState() => _SplitOtpState(
        pin,
        docReq,
        amount,
        balance,
        userReqID,
        userTargetID,
      );
}

class _SplitOtpState extends State<SplitOtp> {
  final TextEditingController tedt = TextEditingController();
  String currentText = "";
  final String _userReqID;
  final String _docReq;
  final String _userTargetID;
  final int _pin;
  final int _amount;
  final int _balance;

  _SplitOtpState(
    this._pin,
    this._docReq,
    this._amount,
    this._balance,
    this._userReqID,
    this._userTargetID,
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference splitbill =
        FirebaseFirestore.instance.collection('splitbill');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AuthSuccess) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/request-success.png',
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter your OTP code number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      padding: EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          PinCodeTextField(
                            obscureText: true,
                            obscuringCharacter: '*',
                            controller: tedt,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            length: 4,
                            onChanged: (value) {
                              debugPrint(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (int.parse(tedt.text) == _pin) {
                                  if (_amount <= _balance) {
                                    print('MASUK TRUE');
                                    print('JUMLAH AMOUNT: $_amount');
                                    print('JUMLAH BALANCE: $_balance');

                                    await users.doc(_userTargetID).update({
                                      'balance': FieldValue.increment(-_amount),
                                    });

                                    await users.doc(_userReqID).update({
                                      'balance': FieldValue.increment(_amount),
                                    });

                                    await splitbill
                                        .doc(_docReq)
                                        .collection('group')
                                        .doc(_userTargetID)
                                        .update({
                                      'status': true,
                                      'statusPayment': true,
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentSuccessPage(),
                                        ));
                                  } else {
                                    print('MASUK ELSE');
                                    print('JUMLAH AMOUNT: $_amount');
                                    print('JUMLAH BALANCE: $_balance}');
                                    // Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('Saldo tidak mencukupi'),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('ERROR'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Didn't you receive any code?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
