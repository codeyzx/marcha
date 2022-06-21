import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';
import 'package:marcha_branch/ui/virtucard/virtucard_set_page.dart';

class VirtucardCreatePage extends StatefulWidget {
  const VirtucardCreatePage({Key? key}) : super(key: key);

  @override
  _VirtucardCreatePageState createState() => _VirtucardCreatePageState();
}

class _VirtucardCreatePageState extends State<VirtucardCreatePage> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    List<String> friends = [''];
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
          "Create Virtucard",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    'Selected (2)',
                    style: subTitleText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 90.h,
                          child: ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 5.h),
                                        SizedBox(
                                          width: 60.w,
                                          height: 83.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r),
                                                  child: Image.network(
                                                    'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                                    width: 60.w,
                                                    height: 60.h,
                                                  )),
                                              Text(
                                                'Joni',
                                                style: nameTxt,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 60.w,
                                      height: 83.h,
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                              onTap: () {},
                                              child: Image.asset(
                                                'assets/images/icon-cross.png',
                                                width: 22.w,
                                                height: 22.h,
                                              ))),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All",
                        style: subTitleText,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Add New (+)",
                          style: addText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              value: _checked,
                              onChanged: (value) {
                                setState(() {
                                  _checked = value!;
                                });
                              },
                              title: Text(
                                'joni yes papa',
                                style: titleName,
                              ),
                              subtitle: Text(
                                'joni@gmail.com',
                                style: username,
                              ),
                              secondary: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.network(
                                  'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              activeColor: buttonMain,
                              checkColor: Colors.white,
                              shape: CircleBorder(),
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                          ],
                        );
                      }),
                  //else kalau gada friend
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24.h,
                      ),
                      Image.asset(
                        'assets/images/group-else-img.png',
                        width: 240.w,
                        height: 108.43.h,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Text(
                        'Belum ada Teman',
                        style: titleElse,
                      ),
                      Text(
                        'Kamu perlu teman untuk membuat Virtucard',
                        style: subTitleElse,
                      ),
                      Text(
                        'Atau kamu bisa membuat virtucard sendiri dengan klik "Selanjutya"',
                        textAlign: TextAlign.center,
                        style: subTitleElse,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
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
                                      builder: (context) => FriendsPage(
                                        friends: friends,
                                      ),
                                    ));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(buttonMain),
                              ),
                              child: Text(
                                'Cari Teman',
                                style: textButton,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: 1.sw,
        height: 70.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: HexColor("#9D20FF").withOpacity(0.20),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ]),
        child: Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 320.w,
              height: 55.h,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VirtucardSetPage(),
                      ));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonMain),
                ),
                child: Text(
                  'Selanjutnya',
                  style: textButton,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
