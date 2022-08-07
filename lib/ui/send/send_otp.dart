import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/ui/send/sendSuccess_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SendOtp extends StatefulWidget {
  final int pin;
  final int amount;
  final int balance;
  final String note;
  final String userSendID;
  final String userSendEmail;
  final String userSendName;
  final String userSendPhoto;
  final String userTargetID;
  final String userTargetEmail;
  final String userTargetName;
  final String userTargetPhoto;
  const SendOtp({
    Key? key,
    required this.pin,
    required this.amount,
    required this.balance,
    required this.note,
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
  _SendOtpState createState() => _SendOtpState(
      pin,
      amount,
      balance,
      note,
      userSendID,
      userSendEmail,
      userSendName,
      userSendPhoto,
      userTargetID,
      userTargetEmail,
      userTargetName,
      userTargetPhoto);
}

class _SendOtpState extends State<SendOtp> {
  final String _userSendID;
  final String _userSendEmail;
  final String _userSendName;
  final String _userSendPhoto;
  final String _userTargetID;
  final String _userTargetEmail;
  final String _userTargetName;
  final String _userTargetPhoto;
  final int _pin;
  final int _amount;
  final int _balance;
  final String _note;
  final TextEditingController tedt = TextEditingController();
  String currentText = "";

  _SendOtpState(
      this._pin,
      this._amount,
      this._balance,
      this._note,
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
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference send = FirebaseFirestore.instance.collection('send');
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
                      "Masukkan pin anda",
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
                                  int saldo = _amount;
                                  // Validate
                                  if (saldo <= _balance) {
                                    // User Target
                                    await users.doc(_userTargetID).update({
                                      'balance': FieldValue.increment(saldo),
                                    });

                                    // User Send
                                    await users.doc(_userSendID).update({
                                      'balance': FieldValue.increment(-saldo),
                                    });

                                    // Send Doc
                                    await send.doc().set({
                                      'userSendID': _userSendID,
                                      'userSendName': _userSendName,
                                      'userSendEmail': _userSendEmail,
                                      'userSendPhoto': _userSendPhoto,
                                      'userTargetID': _userTargetID,
                                      'userTargetName': _userTargetName,
                                      'userTargetEmail': _userTargetEmail,
                                      'userTargetPhoto': _userTargetPhoto,
                                      'startTime': DateTime.now(),
                                      'note': _note,
                                      'amount': saldo,
                                    });

                                    // Navigator
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SendSuccessPage(),
                                        ));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 47, 46, 46),
                                        content: Text('Saldo tidak mencukupi'),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );

                                    // Additional
                                    // Navigator.pop(context);
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
