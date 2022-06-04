import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/qr/qr_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          "My Qr Code",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            String userQr = state.user.email;
            // List<String> userQr = [
            //   // 'ZdTD05iHKYfNjqzyAdyZYhYtJG33',
            //   state.user.id,
            //   // 'Favian Jiwani',
            //   state.user.name,
            //   // 'fabshiet25@gmail.com',
            //   state.user.email,
            //   // 'https://lh3.googleusercontent.com/a/AATXAJxzGPio9JTGbGzzIS4sk_lC1HhEQgQzljQdnQH8=s96-c'
            //   state.user.photo,
            // ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),

                // Align(
                //     alignment: Alignment.topLeft,
                //     child: Image.asset('assets/images/succes-top.png')),
                Center(
                    child: Text(
                  "Scan this qr code",
                  style: subTitleSuccess,
                )),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                    child: QrImage(
                  // data: userQr.toString(),
                  data: userQr,
                  size: 226.65.w,
                  version: QrVersions.auto,
                )
                    // Image.asset(
                    //   'assets/images/request-success.png',
                    //   width: 226.65.w,
                    //   height: 184.54.h,
                    // ),
                    ),
                SizedBox(
                  height: 44.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    child: SizedBox(
                      width: 320.w,
                      height: 55.h,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(
                              style: BorderStyle.solid,
                              color: buttonMain,
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Download",
                          style: textButtonSuccess,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SizedBox(
                      width: 320.w,
                      height: 55.h,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrScan(),
                              ));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(buttonMain),
                        ),
                        child: Text(
                          'Scan Qr Code',
                          style: textButton,
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
      ),
    );
  }
}
