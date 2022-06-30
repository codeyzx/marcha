import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:date_format/date_format.dart';
import 'package:marcha_branch/ui/split_bill/splitBillAdvanced_page.dart';

class SplitBillConfirmPage extends StatefulWidget {
  final bool isGroup;
  final List<String> friendName;
  final List<String> friendID;
  final List<String> friendEmail;
  final List<String> friendDeviceToken;
  final List<String> friendPhoto;
  final String groupID;
  final String userName;
  final String userID;
  final String userEmail;
  final String userPhoto;
  final String note;
  final DateTime dateTime;
  final int amount;

  const SplitBillConfirmPage(
      {Key? key,
      required this.isGroup,
      required this.friendName,
      required this.friendID,
      required this.friendEmail,
      required this.friendDeviceToken,
      required this.friendPhoto,
      required this.groupID,
      required this.userName,
      required this.userID,
      required this.userEmail,
      required this.userPhoto,
      required this.note,
      required this.dateTime,
      required this.amount})
      : super(key: key);

  @override
  _SplitBillConfirmPageState createState() => _SplitBillConfirmPageState(
      isGroup,
      friendName,
      friendID,
      friendEmail,
      friendDeviceToken,
      friendPhoto,
      groupID,
      userName,
      userID,
      userEmail,
      userPhoto,
      note,
      dateTime,
      amount);
}

class _SplitBillConfirmPageState extends State<SplitBillConfirmPage> {
  final List<String> _friendName;
  final List<String> _friendID;
  final List<String> _friendEmail;
  final List<String> _friendDeviceToken;
  final List<String> _friendPhoto;
  final bool isGroup;
  final String _groupID;
  final String _userName;
  final String _userID;
  final String _userEmail;
  final String _userPhoto;
  final String _note;
  final DateTime _dateTime;
  final int _amount;

  _SplitBillConfirmPageState(
      this.isGroup,
      this._friendName,
      this._friendID,
      this._friendEmail,
      this._friendDeviceToken,
      this._friendPhoto,
      this._groupID,
      this._userName,
      this._userID,
      this._userEmail,
      this._userPhoto,
      this._note,
      this._dateTime,
      this._amount);

  @override
  Widget build(BuildContext context) {
    final divideAmount = _amount / _friendName.length;
    print('divide amount : $divideAmount');
    return isGroup
        ?
        // Group Payment
        Scaffold(
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
                "Group Payment",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      "Information",
                      style: subTitleText,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          convertToIdr(_amount),
                          // "Rp $_amount",
                          style: inputNumber,
                        ),
                        Text(
                          formatDate(_dateTime, [dd, ' - ', MM, ' - ', yyyy]),
                          style: noteTxt,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      _note,
                      style: subTitleSuccess,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Details:",
                          style: subTitleText,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Advanced",
                            style: addText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _friendName.length,
                      itemBuilder: (context, int index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: Image.network(
                                          _friendPhoto[index],
                                          width: 60.w,
                                          height: 60.w,
                                        )),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            _friendName[index],
                                            style: nameSplit,
                                            // maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        // Text(
                                        //   "50%",
                                        //   style: amountTxt,
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  // "Rp $format(${divideAmount.toDouble()})",
                                  // "Rp ${divideAmount.toStringAsFixed(0)}",
                                  convertToIdr(int.tryParse(
                                      divideAmount.toStringAsFixed(0))),
                                  style: amountSplit,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              width: 1.sw,
              height: 80.h,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 320.w,
                    height: 60.h,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplitBillAdvancedPage(
                                friendName: _friendName,
                                friendID: _friendID,
                                friendEmail: _friendEmail,
                                friendPhoto: _friendPhoto,
                                userName: _userName,
                                userID: _userID,
                                userEmail: _userEmail,
                                userPhoto: _userPhoto,
                                note: _note,
                                amounts: _amount,
                                dateTime: _dateTime,
                                isGroup: true,
                                groupID: _groupID,
                                friendDeviceToken: _friendDeviceToken,
                              ),
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
            ))
        :
        // Split Bill
        Scaffold(
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
                "Split Bill",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      "Information",
                      style: subTitleText,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          convertToIdr(_amount),
                          // "Rp $_amount",
                          style: inputNumber,
                        ),
                        Text(
                          formatDate(_dateTime, [dd, ' - ', MM, ' - ', yyyy]),
                          style: noteTxt,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      _note,
                      style: subTitleSuccess,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Details:",
                          style: subTitleText,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Advanced",
                            style: addText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _friendName.length,
                      itemBuilder: (context, int index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: Image.network(
                                          _friendPhoto[index],
                                          width: 60.w,
                                          height: 60.w,
                                        )),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            _friendName[index],
                                            style: nameSplit,
                                            // maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        // Text(
                                        //   "50%",
                                        //   style: amountTxt,
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  // "Rp $format(${divideAmount.toDouble()})",
                                  // "Rp ${divideAmount.toStringAsFixed(0)}",
                                  convertToIdr(int.tryParse(
                                      divideAmount.toStringAsFixed(0))),
                                  style: amountSplit,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              width: 1.sw,
              height: 80.h,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 320.w,
                    height: 60.h,
                    child: TextButton(
                      onPressed: () {
                        print('split bill confirm page');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplitBillAdvancedPage(
                                friendName: _friendName,
                                friendID: _friendID,
                                friendEmail: _friendEmail,
                                friendPhoto: _friendPhoto,
                                userName: _userName,
                                userID: _userID,
                                userEmail: _userEmail,
                                userPhoto: _userPhoto,
                                note: _note,
                                amounts: _amount,
                                dateTime: _dateTime,
                                isGroup: false,
                                groupID: _groupID,
                                friendDeviceToken: _friendDeviceToken,
                              ),
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
            ));
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
