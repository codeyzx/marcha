import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';

class PaymentInElsePage extends StatelessWidget {
  const PaymentInElsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 58.h,),
          Image.asset('assets/images/else-payment-img.png', width: 150.w, height: 146.42.h,),
          SizedBox(height: 27.h,),
          Text('Tidak Ada Tagihan', style: titleElse,),
        ],
      ),
    );
  }
}
