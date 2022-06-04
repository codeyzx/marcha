import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:marcha_branch/ui/groups/group_page.dart';

class GroupSuccessPage extends StatelessWidget {
  final bool isAdd;
  const GroupSuccessPage({Key? key, required this.isAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAdd
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/succes-top.png')),
                Center(
                  child: Image.asset(
                    'assets/images/request-success.png',
                    width: 226.65.w,
                    height: 184.54.h,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                    child: Text(
                  "Hooray!",
                  style: successTitle,
                )),
                Center(
                    child: Text(
                  "Success add friends to Group!",
                  // "Request to group is Successful!",
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BotNavBar(),
                              ));
                          // Navigator.pushReplacementNamed(context, '/nav-bar');
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
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupPage(),
                              ));
                          // Navigator.pushNamed(context, '/split-bill');
                        },
                        child: Text(
                          "Kembali ke Group",
                          style: textButtonSuccess,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/succes-top.png')),
                Center(
                  child: Image.asset(
                    'assets/images/request-success.png',
                    width: 226.65.w,
                    height: 184.54.h,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                    child: Text(
                  "Hooray!",
                  style: successTitle,
                )),
                Center(
                    child: Text(
                  "Request to group is Successful!",
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/split-bill');
                        },
                        child: Text(
                          "Kembali ke Group",
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
