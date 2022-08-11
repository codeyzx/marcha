import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marcha_branch/shared/theme.dart';

class TopUpDetailPage extends StatelessWidget {
  final String items;
  final String merchant;
  final String status;
  final String orderId;
  final String docsId;

  const TopUpDetailPage(
      {Key? key,
      required this.items,
      required this.merchant,
      required this.status,
      required this.orderId,
      required this.docsId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Top Up",
          style: titleEdit,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: buttonMain.withOpacity(0.40),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/icon_add.png',
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Top Up Berhasil Diproses',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  items,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                Divider(
                  thickness: 0.8,
                  height: 10.h,
                ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merchant',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      merchant,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      items,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      topUpName(status),
                      style: statusTopUp(status),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Id',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      orderId,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Id Transaksi',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      docsId,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    child: SizedBox(
                      width: 320.w,
                      height: 41.h,
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
                          "Bagikan",
                          style: textButtonSuccess,
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
    );
  }
}
