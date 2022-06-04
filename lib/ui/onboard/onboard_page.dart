import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/onboard/v_login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:marcha_branch/shared/theme.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(bottom: 77.h),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/top-bg-1.png',
                    width: 1.sw,
                  ),
                  Image.asset(
                    'assets/images/onboard-img-1.png',
                    width: 250.05.w,
                    height: 170.68.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "Kirim Uang dengan Mudah",
                    style: titleOnBoard,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Kirim uang ke teman atau\nkeluargamu dengan mudah.",
                    style: subTitleOnBoard,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/top-bg-2.png',
                    width: 1.sw,
                  ),
                  SizedBox(
                    height: 63.31.h,
                  ),
                  Image.asset(
                    'assets/images/onboard-img-3.png',
                    width: 250.05.w,
                    height: 170.68.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text("Hindari Kecanggungan", style: titleOnBoard),
                  SizedBox(height: 12.h),
                  Text(
                    "Kirim permintaan ke temanmu dengan cepat dan mudah.",
                    style: subTitleOnBoard,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/top-bg-3.png',
                    width: 1.sw,
                  ),
                  SizedBox(
                    height: 63.31.h,
                  ),
                  Image.asset(
                    'assets/images/onboard-img-2.png',
                    width: 250.05.w,
                    height: 170.68.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text("Atur Transaksi Bersama", style: titleOnBoard),
                  SizedBox(height: 12.h),
                  Text(
                    "Rasakan kemudahan mengatur transaksi besama.",
                    style: subTitleOnBoard,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
              padding: EdgeInsets.only(bottom: 35.h, left: 30.w, right: 30.w),
              height: 153.h,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotWidth: 12.w,
                        dotHeight: 12.h,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 320.w,
                    height: 42.h,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonMain),
                      ),
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: Text(
                        'Mulai Sekarang',
                        style: textButton,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(bottom: 35.h, left: 30.w, right: 30.w),
              height: 153.h,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotWidth: 12.w,
                        dotHeight: 12.h,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120.w,
                        height: 42.h,
                        child: TextButton(
                          onPressed: () {
                            controller.jumpToPage(2);
                          },
                          child: Text(
                            'Skip',
                            style: unTextButton,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120.w,
                        height: 42.h,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(buttonMain),
                          ),
                          onPressed: () {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            'Next',
                            style: textButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
