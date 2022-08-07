import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  final bool isExist;
  const Otp({Key? key, required this.isExist}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _OtpState createState() => _OtpState(isExist);
}

class _OtpState extends State<Otp> {
  final bool _isExist;
  final TextEditingController tedt = TextEditingController();
  String currentText = "";

  _OtpState(this._isExist);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
                return _isExist
                    ? Column(
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
                                    onPressed: () {
                                      print(int.parse(tedt.text));
                                      print(state.user.pin);
                                      int.parse(tedt.text) == state.user.pin
                                          ? Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BotNavBar(),
                                              ))
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                              SnackBar(
                                                content: Text('ERROR'),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
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
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
                      )
                    : Column(
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
                            "Kamu belum pernah membuat pin, tolong daftarkan PIN.",
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
                                      print(int.parse(tedt.text));
                                      await users.doc(state.user.id).update(
                                          {'pin': int.parse(tedt.text)});

                                      Navigator.pop(context);
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => BotNavBar(),
                                      //     ));
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
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
