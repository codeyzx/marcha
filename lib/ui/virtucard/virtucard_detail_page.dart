import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';

class VirtucardDetailPage extends StatefulWidget {
  const VirtucardDetailPage({Key? key}) : super(key: key);

  @override
  _VirtucardDetailPageState createState() => _VirtucardDetailPageState();
}

class _VirtucardDetailPageState extends State<VirtucardDetailPage> {
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
          "Virtucard nama",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.network(
                      "https://static.republika.co.id/uploads/images/inpicture_slide/delegasi-indonesoa-di-sidang-umum-pbb-tahun-1947-terlihat-_181010145459-862.jpg",
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  'Uang Kas',
                  style: nameDetVC,
                ),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "with",
                  style: subTitleText,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Add New",
                    style: addText,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 1.sw,
                    height: 75.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: SizedBox(
                            width: 60.w,
                            height: 83.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.network(
                                      'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                      width: 50.w,
                                      height: 50.h,
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
              height: 20.h,
            ),
            Text(
              'Amount to pay:',
              style: subTitleText,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Rp 12.000',
              style: moneyDetVC,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Due:',
              style: subTitleText,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              '12 Apr 2022',
              style: dateDetVC,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Send to:',
              style: subTitleText,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              '123-321-123',
              style: moneyVC,
            ),
            Spacer(),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    child: SizedBox(
                      width: 1.sw,
                      height: 50.h,
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
                        onPressed: () {},
                        child: Text(
                          "Settings",
                          style: textButtonSuccess,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
