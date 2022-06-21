import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/request/request_page.dart';

class PaymentOutElsePage extends StatelessWidget {
  const PaymentOutElsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 58.h,),
          Image.asset('assets/images/else-payment-img.png', width: 150.w, height: 146.42.h,),
          SizedBox(height: 27.h,),
          Text('Belum Melakukan Request', style: titleElse,),
          Text('Kirim Request ke temanmu', style: subTitleElse,),
          SizedBox(height: 18.h,),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: SizedBox(
                width: 180.w,
                height: 46.h,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                              RequestPage(),
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(buttonMain),
                  ),
                  child: Text(
                    'Request',
                    style: textButton,
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
