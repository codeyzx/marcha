import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/virtucard/virtucard_create_page.dart';
import 'package:marcha_branch/ui/virtucard/virtucard_detail_page.dart';

class VirtucardPage extends StatefulWidget {
  const VirtucardPage({Key? key}) : super(key: key);

  @override
  _VirtucardPageState createState() => _VirtucardPageState();
}

class _VirtucardPageState extends State<VirtucardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Virtucard",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('EBEDEE'),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search_rounded),
                      onPressed: () {},
                    ),
                    iconColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    labelText: "Search by Username",
                    labelStyle: searchTxt,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Virtucard",
                      style: subTitleText,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VirtucardCreatePage(),
                            ));
                      },
                      child: Text(
                        "Create New (+)",
                        style: addText,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VirtucardDetailPage(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: Image.network(
                                          'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                          width: 60.w,
                                          height: 60.h,
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 170.w,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Netflix Bareng',
                                                    // 'Ahmad Joni',
                                                    style: nameVC,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Next Payment: 30 Apr',
                                          style: dateVC,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 74.w,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Rp 20.000',
                                        // 'Ahmad Joni',
                                        style: moneyVC,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      );
                    }),
                //else kalau belum ada virtucard
                // Column(
                //   children: [
                //     SizedBox(
                //       height: 30.h,
                //     ),
                //     Image.asset(
                //       'assets/images/history-else-img.png',
                //       width: 240.w,
                //       height: 166.61.h,
                //     ),
                //     SizedBox(
                //       height: 27.h,
                //     ),
                //     Text(
                //       'Tidak ada Virtucard',
                //       style: titleElse,
                //     ),
                //     Text(
                //       'Buat virtucard terlebih dahulu',
                //       style: subTitleElse,
                //     ),
                //     SizedBox(
                //       height: 18.h,
                //     ),
                //     Align(
                //       alignment: Alignment.center,
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(6.r),
                //         child: SizedBox(
                //           width: 180.w,
                //           height: 46.h,
                //           child: TextButton(
                //             onPressed: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) => VirtucardCreatePage(),
                //                   ));
                //             },
                //             style: ButtonStyle(
                //               backgroundColor:
                //                   MaterialStateProperty.all(buttonMain),
                //             ),
                //             child: Text(
                //               'Buat',
                //               style: textButton,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
