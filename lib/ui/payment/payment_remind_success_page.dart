import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';

class RemindSuccessPage extends StatelessWidget {
  const RemindSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset('assets/images/succes-top.png')),
              Center(
                child: Image.asset(
                  'assets/images/remind-success.png',
                  width: 216.33.w,
                  height: 180.h,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Center(
                  child: Text(
                    "Ting!",
                    style: successTitle,
                  )),
              Center(
                  child: Text(
                    "Success to give reminder!",
                    style: subTitleSuccess,
                  )),
              SizedBox(
                height: 44.h,
              ),
            ],
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 320.w,
                    height: 55.h,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                                  context, '/nav-bar');
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => BotNavBar(),
                        //     ));
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
                height: 25.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
