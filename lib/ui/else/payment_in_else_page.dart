import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/search_page.dart';
import 'package:marcha_branch/ui/groups/group_add.dart';
import 'package:marcha_branch/ui/groups/group_chat_detail_page.dart';

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
