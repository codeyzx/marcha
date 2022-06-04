import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:marcha_branch/ui/friends/search_page.dart';
import 'package:marcha_branch/ui/groups/group_add.dart';
import 'package:marcha_branch/ui/groups/group_chat_detail_page.dart';
import 'package:marcha_branch/ui/request/request_page.dart';

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F8F6FF'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: buttonMain,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Development Page",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 60.h,),
          Image.asset('assets/images/development-img.png', width: 280.w, height: 172.23.h,),
          SizedBox(height: 12.77.h,),
          Text('Dalam Development', style: titleElse,),
          Text('Maaf halaman ini masih di tahap development', style: subTitleElse,),
          SizedBox(height: 30.h,),
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
                              BotNavBar(),
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(buttonMain),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
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
