import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marcha_branch/shared/theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _items = [];

  final box = Hive.box('notif');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  // Get all items from the database
  void _refreshItems() {
    final data = box.keys.map((key) {
      final value = box.get(key);
      return {"key": key, "title": value["title"], "body": value["body"]};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            "Notification",
            style: titleEdit,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    'Baru',
                    style: labelNotification,
                  ),
                  TextButton(
                    onPressed: () {
                      box.clear();
                    },
                    child: Text(
                      'Hapus Notifikasi',
                      style: labelNotification,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  _items.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (BuildContext context, int index) {
                            // print('ini items: ${_items[index]}');
                            final currentItem = _items[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  width: 1.sw,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor("#9D20FF")
                                              .withOpacity(0.10),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                          offset: Offset(2, 2),
                                        ),
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    // width: 170.w,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          currentItem["title"],
                                                          // 'Ahmad Joni',
                                                          style:
                                                              nameNotification,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width: 300.w,
                                                  child: Text(
                                                    currentItem["body"],
                                                    style: personPayment,
                                                    textAlign: TextAlign.left,
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 24.h,
                                ),
                              ],
                            );
                          })
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 58.h,
                              ),
                              Image.asset(
                                'assets/images/history-else-img.png',
                                width: 240.w,
                                height: 166.61.h,
                              ),
                              SizedBox(
                                height: 27.h,
                              ),
                              Text(
                                'Tidak ada Notifikasi',
                                style: titleElse,
                              ),
                              Text(
                                'Belum ada notifikasi terbaru ',
                                style: subTitleElse,
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ));
  }
}
