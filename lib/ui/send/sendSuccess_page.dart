import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/send/send_page.dart';

class SendSuccessPage extends StatelessWidget {
  const SendSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/succes-top.png')),
          Center(
            child: Image.asset(
              'assets/images/happy.png',
              width: 226.65.w,
              height: 184.54.h,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Center(
              child: Text(
            "Yay!",
            style: successTitle,
          )),
          Center(
              child: Text(
            "Your payment is Successful!",
            style: subTitleSuccess,
          )),
          SizedBox(
            height: 44.h,
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
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => BotNavBar(),
                    //     ));
                    Navigator.pushReplacementNamed(context, '/nav-bar');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(buttonMain),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: textButton,
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
              child: SizedBox(
                width: 320.w,
                height: 55.h,
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendPage(),
                        ));
                  },
                  child: Text(
                    "Kirim Lagi",
                    style: textButtonSuccess,
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
