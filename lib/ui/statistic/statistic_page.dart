import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/history/history_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('01 - 10', 450000, 845000, 15000),
      _ChartData('11 - 20', 845000, 650000, 150000),
      _ChartData('21 - 31', 200000, 654500, 150000),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference request =
        FirebaseFirestore.instance.collection('request');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: HexColor('#F8F6FF'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Statistic",
            style: titleEdit,
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: tabTitlePayment,
            labelColor: Colors.black,
            unselectedLabelStyle: unTabTitlePayment,
            unselectedLabelColor: HexColor('#9D9D9D'),
            tabs: const [
              Tab(
                text: 'This Month',
              ),
              Tab(
                text: 'Previous Month',
              )
            ],
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AuthSuccess) {
              return TabBarView(
                children: [
                  ListView(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 1.sw,
                        height: 350.h,
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.simpleCurrency(
                                    locale: 'id', decimalDigits: 0),
                                minimum: 0,
                                maximum: 1000000,
                                interval: 50000),
                            tooltipBehavior: _tooltip,
                            series: <CartesianSeries>[
                              ColumnSeries<_ChartData, String>(
                                  name: 'Pemasukan',
                                  xAxisName: 'SADASD',
                                  dataSource: data,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y),
                              ColumnSeries<_ChartData, String>(
                                  name: 'Pengeluaran',
                                  xAxisName: 'SADASD',
                                  dataSource: data,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) =>
                                      data.y1),
                            ]),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last Activity',
                                  style: subTitleFriend,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryPage(),
                                        ));
                                  },
                                  child: Text(
                                    "See all",
                                    style: addText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            // History User Request
                            StreamBuilder<QuerySnapshot>(
                              stream: request
                                  .where('userReqEmail',
                                      isEqualTo: state.user.email)
                                  .where('statusPayment', isEqualTo: true)
                                  // .orderBy('startTime', descending: false)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: (snapshot.data!)
                                        .docs
                                        .map(
                                          (e) => Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.h,
                                                    horizontal: 10.w),
                                                width: 1.sw,
                                                height: 70.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: HexColor(
                                                                "#9D20FF")
                                                            .withOpacity(0.10),
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(2, 2),
                                                      ),
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                          //image profile
                                                          child: Image.network(
                                                            e['userTargetPhoto'],
                                                            // "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                                                            width: 50.w,
                                                            height: 50.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 12.w,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 127.w,
                                                              child: Text(
                                                                e['userTargetName'],
                                                                // "Vladimir Putin",
                                                                style:
                                                                    titleName,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              formatDate(
                                                                  e['startTime']
                                                                      .toDate(),
                                                                  [
                                                                    dd,
                                                                    ' ',
                                                                    MM,
                                                                    ',  ',
                                                                    // yyyy
                                                                    HH,
                                                                    ':',
                                                                    nn
                                                                  ]),
                                                              // "17 Feb, 13:30",
                                                              style: timeHome,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      // "Rp -${e['amount']}",
                                                      "+ ${convertToIdr(e['amount'])}",
                                                      style: moneyActivity,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),

                            // ListView.builder(
                            //     shrinkWrap: true,
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: 5,
                            //     itemBuilder: (BuildContext context, int index){
                            //       return Column(
                            //           children: [
                            //             Container(
                            //               width: 1.sw,
                            //               height: 70.h,
                            //               margin: EdgeInsets.only(bottom: 10.h),
                            //               decoration: BoxDecoration(
                            //                   color: Colors.white,
                            //                   boxShadow: [
                            //                     BoxShadow(
                            //                       color: HexColor('#9D20FF').withOpacity(0.10),
                            //                       blurRadius: 5,
                            //                       spreadRadius: 0,
                            //                       offset: Offset(2, 2),
                            //                     )
                            //                   ]
                            //               ),
                            //               child: Padding(
                            //                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                            //                 child: Row(
                            //                   mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //                   crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //                   children: [
                            //                     Row(
                            //                       crossAxisAlignment:
                            //                       CrossAxisAlignment.center,
                            //                       children: [
                            //                         ClipRRect(
                            //                           borderRadius:
                            //                           BorderRadius.circular(15.r),
                            //                           //image profile
                            //                           child: Image.network(
                            //                             "https://statik.tempo.co/data/2021/07/01/id_1031698/1031698_720.jpg",
                            //                             width: 50.w,
                            //                             height: 50.h,
                            //                             fit: BoxFit.cover,
                            //                           ),
                            //                         ),
                            //                         SizedBox(
                            //                           width: 12.w,
                            //                         ),
                            //                         Column(
                            //                           mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceBetween,
                            //                           crossAxisAlignment:
                            //                           CrossAxisAlignment.start,
                            //                           children: [
                            //                             SizedBox(
                            //                               width: 127.w,
                            //                               child: Text(
                            //                                 "Vladimir Putin",
                            //                                 style: titleName,
                            //                                 maxLines: 1,
                            //                                 overflow:
                            //                                 TextOverflow.ellipsis,
                            //                               ),
                            //                             ),
                            //                             Text(
                            //                               "17 Feb, 13:30",
                            //                               style: timeHome,
                            //                             ),
                            //                           ],
                            //                         ),
                            //                       ],
                            //                     ),
                            //                     Text(
                            //                       "+ Rp 50.000",
                            //                       style: moneyActivity,
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //       );
                            //     }
                            // ),

                            SizedBox(
                              height: 30.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      // //else kalau kosong
                      Center(
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
                              'Tidak ada Aktivitas Transaksi',
                              style: titleElse,
                            ),
                            Text(
                              'Belum ada transaksi bulan lalu ',
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
                ],
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
}
