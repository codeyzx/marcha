import 'package:flutter/material.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/payment/payment_page.dart';
import 'package:marcha_branch/ui/profile/profile_page.dart';
import 'package:marcha_branch/ui/qr/qr_scan.dart';
import 'package:marcha_branch/ui/statistic/statistic_page.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({
    Key? key,
  }) : super(key: key);

  @override
  _BotNavBarState createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  int currentIndex = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();

  _BotNavBarState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset(
          'assets/images/icon-scan-nav.png',
          width: 30.w,
          height: 30.h,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrScan(),
                // builder: (context) => QrPage(),
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 62.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage();
                        currentIndex = 0;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 0
                              ? 'assets/images/home-nav-active.png'
                              : 'assets/images/home-nav-off.png',
                          width: 30.w,
                          height: 30.h,
                        ),
                        Text(
                          'Home',
                          style:
                              currentIndex == 0 ? txtSelected : txtUnSelected,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = PaymentPage();
                        currentIndex = 1;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 1
                              ? 'assets/images/payment-nav-active.png'
                              : 'assets/images/payment-nav-off.png',
                          width: 30.w,
                          height: 30.h,
                        ),
                        Text(
                          'Payment',
                          style:
                              currentIndex == 1 ? txtSelected : txtUnSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = StatisticPage();
                        currentIndex = 2;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 2
                              ? 'assets/images/stat-nav-active.png'
                              : 'assets/images/stat-nav-off.png',
                          width: 30.w,
                          height: 30.h,
                        ),
                        Text(
                          'Statistic',
                          style:
                              currentIndex == 2 ? txtSelected : txtUnSelected,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = ProfilePage();
                        currentIndex = 3;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currentIndex == 3
                              ? 'assets/images/profile-nav-active.png'
                              : 'assets/images/profile-nav-off.png',
                          width: 30.w,
                          height: 30.h,
                        ),
                        Text(
                          'Profile',
                          style:
                              currentIndex == 3 ? txtSelected : txtUnSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: buildNavBar(context),
    );
  }

  // Container buildNavBar(BuildContext context) {
  //   return Container(
  //     height: 75.h,
  //     color: Colors.white.withOpacity(0),
  //     child: Stack(
  //       clipBehavior: Clip.none,
  //       children: [
  //         Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Container(
  //             height: 62.h,
  //             width: 1.sw,
  //             decoration: BoxDecoration(
  //               color: Colors.white.withOpacity(0),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: HexColor("#9D20FF").withOpacity(0.15),
  //                   blurRadius: 20,
  //                   spreadRadius: 0,
  //                   offset: Offset(0, -5),
  //                 ),
  //               ],
  //             ),
  //             child: BottomNavigationBar(
  //               currentIndex: currentIndex,
  //               onTap: (value) => setState(() => currentIndex = value),
  //               type: BottomNavigationBarType.fixed,
  //               backgroundColor: Colors.white,
  //               unselectedItemColor: Colors.black.withOpacity(0.35),
  //               selectedItemColor: buttonMain,
  //               selectedLabelStyle: txtSelected,
  //               unselectedLabelStyle: txtUnSelected,
  //               items: const [
  //                 BottomNavigationBarItem(
  //                   icon: FaIcon(
  //                     FontAwesomeIcons.homeAlt,
  //                   ),
  //                   label: "Home",
  //                 ),
  //                 BottomNavigationBarItem(
  //                   icon: FaIcon(FontAwesomeIcons.moneyBill),
  //                   label: "Payment",
  //                 ),
  //                 //buat di tengah
  //                 BottomNavigationBarItem(
  //                   icon: FaIcon(
  //                     FontAwesomeIcons.house,
  //                   ),
  //                   label: "~",
  //                 ),
  //                 BottomNavigationBarItem(
  //                   icon: FaIcon(FontAwesomeIcons.chartBar),
  //                   label: "Statistic",
  //                 ),
  //                 BottomNavigationBarItem(
  //                   icon: FaIcon(FontAwesomeIcons.user),
  //                   label: "Profile",
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Align(
  //           alignment: Alignment.topCenter,
  //           child: GestureDetector(
  //             onTap: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => QrScan(),
  //                   ));
  //               print("tapped Scan QR");
  //             },
  //             child: Container(
  //               width: 60.w,
  //               height: 60.w,
  //               decoration: BoxDecoration(
  //                 color: buttonMain,
  //                 borderRadius: BorderRadius.circular(20.r),
  //               ),
  //               child: Center(
  //                 child: Image.asset(
  //                   'assets/images/icon-scan-nav.png',
  //                   width: 30.w,
  //                   height: 30.h,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
}
