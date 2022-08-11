import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/home/topup_detail_page.dart';

class HistoryTopUpPage extends StatelessWidget {
  final String uid;
  const HistoryTopUpPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

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
          "History Top Up",
          style: titleEdit,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: StreamBuilder<QuerySnapshot>(
          stream: orders.where('customerId', isEqualTo: uid).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: (snapshot.data!)
                    .docs
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 15.h,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopUpDetailPage(
                                        items: e['items'],
                                        merchant:
                                            e['methodPayment'].toUpperCase(),
                                        status: e['status'],
                                        orderId: e['orderId'],
                                        docsId: e.id)));
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e['methodPayment'].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    topUpName(e['status']),
                                    style: statusTopUp(e['status']),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    formatDate(e['createdAt'].toDate(),
                                        [dd, ' ', MM, ',  ', HH, ':', nn]),
                                    style: timeHome,
                                  ),
                                  Text(
                                    e['items'],
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.8,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
