import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:date_format/date_format.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:marcha_branch/ui/virtucard/virtucard_page.dart';


class VirtucardSetPage extends StatefulWidget {
  const VirtucardSetPage({Key? key}) : super(key: key);

  @override
  _VirtucardSetPageState createState() => _VirtucardSetPageState();
}

class _VirtucardSetPageState extends State<VirtucardSetPage> {
  final TextEditingController _groupName = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  DateTime dateTime = DateTime.now();

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
        "Set Virtucard",
        style: appbarTxt,
      ),
      centerTitle: true,
    ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 70.h),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: SizedBox(
                            width: 85.w,
                            height: 85.h,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.network(
                                      "https://static.republika.co.id/uploads/images/inpicture_slide/delegasi-indonesoa-di-sidang-umum-pbb-tahun-1947-terlihat-_181010145459-862.jpg",
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                    )),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 28.w,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      color: HexColor("#ECDAFF"),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                          'assets/images/icon_camera.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 222.w,
                          height: 35.h,
                          padding: EdgeInsets.only(left: 5.w),
                          child: TextFormField(
                            controller: _groupName,
                            decoration: InputDecoration(
                              hintText: "Group Name",
                              hintStyle: hintGroupName,
                            ),
                            style: inputGroupName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h,),
                    Text('Member 3', style: subTitleText,),
                    SizedBox(height: 10.h,),
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
                                  padding: const EdgeInsets.only(
                                      right: 15.0),
                                  child: SizedBox(
                                    width: 60.w,
                                    height: 83.h,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15.r),
                                            child:
                                            Image.network(
                                              'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                              width: 60.w,
                                              height: 60.h,
                                            )),
                                        Text(
                                          'Joni',
                                          style: nameTxt,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          textAlign:
                                          TextAlign.center,
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
                    SizedBox(height: 12.h,),
                    Text('Amount per person', style: subTitleText,),
                    SizedBox(height: 10.h,),
                    TextField(
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        )
                      ],
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nominal Uang',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#ECDAFF'),
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#ECDAFF'),
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      style: inputNote,
                    ),
                    SizedBox(height: 12.h,),
                    Text('Payment Deadline', style: subTitleText,),
                    SizedBox(height: 10.h,),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 1.sw,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(width: 2.w, color: HexColor('#ECDAFF')),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDate(dateTime, [dd, ' - ', MM, ' - ', yyyy]),
                            style: hintTxt,
                          ),
                          InkWell(
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2069))
                                    .then((date) {
                                  setState(() {
                                    if (date == null) {
                                      dateTime = DateTime.now();
                                    } else {
                                      dateTime = date;
                                    }
                                  });
                                });
                              },
                              child: Image.asset(
                                'assets/images/Date_range.png',
                                width: 30.w,
                                height: 30.h,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h,),
                    Text('Send To', style: subTitleText,),
                    SizedBox(height: 10.h,),
                    TextField(
                      controller: _note,
                      decoration: InputDecoration(
                        hintText: '123-321-123',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#ECDAFF'),
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor('#ECDAFF'),
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      style: inputNote,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ],
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VirtucardPage(),
                      ));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonMain),
                ),
                child: Text(
                  'Buat Virtucard',
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
