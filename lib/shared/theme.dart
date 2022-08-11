import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Color buttonMain = HexColor('#8C3FDB');
TextStyle textButton = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
);
TextStyle unTextButton = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
);

// onboarding text style
TextStyle titleOnBoard = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 20.sp,
);

TextStyle subTitleOnBoard = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w300,
  fontSize: 16.sp,
);

//login & signup text style
TextStyle titleLog = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 30.sp,
);

TextStyle labelLog = GoogleFonts.poppins(
  color: HexColor('#9D9D9D'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle linkLog = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle orTxt = GoogleFonts.poppins(
  color: HexColor('#9D9D9D'),
  fontWeight: FontWeight.w400,
  fontSize: 16.sp,
);

TextStyle normalTxt = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.75),
  fontWeight: FontWeight.w400,
  fontSize: 15.sp,
);

TextStyle smallTxt = GoogleFonts.poppins(
  color: HexColor('#606060'),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle appbarTxt = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 18.sp,
);

TextStyle searchTxt = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.75),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle subTitleText = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 14.sp,
);

TextStyle nameTxt = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle addText = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle titleName = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle username = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

//send detail
TextStyle nameTitle = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 24.sp,
);

TextStyle usernameDet = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 16.sp,
);

TextStyle inputNumber = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 28.sp,
);
TextStyle inputNumberTestHapusAja = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 18.sp,
);

TextStyle inputNote = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle subTitle2 = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle amountTxt = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
);

TextStyle noteTxt = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

//request
TextStyle hintTxt = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.40),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

//split bill
TextStyle nameSplit = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.70),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle amountSplit = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
);

TextStyle statusSplit = GoogleFonts.poppins(
  color: HexColor("#229A35"),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle statusSplitRed = GoogleFonts.poppins(
  color: HexColor("#DB3F3F"),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle statusSplitRedSub = GoogleFonts.poppins(
  color: HexColor("#DB3F3F"),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

//create group
TextStyle hintGroupName = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.60),
  fontWeight: FontWeight.w400,
  fontSize: 18.sp,
);

TextStyle inputGroupName = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
);

//success
TextStyle successTitle = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w600,
  fontSize: 24.sp,
);

TextStyle subTitleSuccess = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle textButtonSuccess = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle statusTopUpSettlement = GoogleFonts.poppins(
  color: HexColor('#229A35'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);
TextStyle statusTopUpPending = GoogleFonts.poppins(
  color: HexColor('#000000').withOpacity(0.6),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);
TextStyle statusTopUpFailed = GoogleFonts.poppins(
  color: HexColor('#DB3F3F'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

String topUpName(String name) {
  switch (name) {
    case 'settlement':
      return 'Berhasil';
    case 'pending':
      return 'Menunggu';
    case 'expire':
      return 'Gagal';
    case 'failed':
      return 'Gagal';
    default:
      return name;
  }
}

TextStyle statusTopUp(String status) {
  switch (status) {
    case 'settlement':
      return statusTopUpSettlement;
    case 'pending': 
      return statusTopUpPending;
    case 'expire':
      return statusTopUpFailed;
    case 'failed':
      return statusTopUpFailed;
    default:
      return statusTopUpPending;
  }
}

//friends
TextStyle subTitleFriend = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 14.sp,
);

TextStyle txtButtonFriend = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 13.sp,
);

TextStyle txtButtonWhiteFriend = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 13.sp,
);

//botnavbar
TextStyle txtSelected = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle txtUnSelected = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.35),
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

//homepage
TextStyle txtWelcome = GoogleFonts.poppins(
  color: Colors.white.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle txtNameHome = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 13.sp,
);

TextStyle subTitleWhite = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle moneyWhiteHome = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 32.sp,
);

TextStyle itemWhite = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
  height: 1.8,
);

TextStyle itemBlack = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
  height: 1.8,
);

TextStyle timeHome = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.70),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle moneyActivity = GoogleFonts.poppins(
  color: HexColor('#229A35'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle moneyActivityPending = GoogleFonts.poppins(
  color: HexColor('#000000').withOpacity(0.7),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle moneyActivityLoss = GoogleFonts.poppins(
  color: HexColor('#DB3F3F'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle moreTitleHome = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle titleElseHome = GoogleFonts.poppins(
  color: HexColor('#606060'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle titleSubElseHome = GoogleFonts.poppins(
  color: HexColor('#606060'),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

//pin page
TextStyle titlePin = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 18.sp,
);

TextStyle numPin = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 22.sp,
);

//payment page
TextStyle titleAppPayment = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontSize: 20.sp,
);

TextStyle tabTitlePayment = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle unTabTitlePayment = GoogleFonts.poppins(
  color: HexColor('#9D9D9D'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle personPayment = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle moneyPayment = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
);

TextStyle statusPayment = GoogleFonts.poppins(
  color: HexColor('#FFA800'),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle statusOverPayment = GoogleFonts.poppins(
  color: HexColor('#DB3F3F'),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle buttonPayment = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle rejectPayment = GoogleFonts.poppins(
  color: HexColor('#DB3F3F'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle namePayment = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle acceptPayment = GoogleFonts.poppins(
  color: HexColor('#229A35'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

//profile page
TextStyle nameProfile = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
);

TextStyle usernameProfile = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle sayHelloProfile = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle manyFriendProfile = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle subFriendProfile = GoogleFonts.poppins(
  color: HexColor('#606060'),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle itemTitleProfile = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.70),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle itemProfile = GoogleFonts.poppins(
  color: HexColor('#231F20'),
  fontWeight: FontWeight.w400,
  fontSize: 16.sp,
);

TextStyle logoutProfile = GoogleFonts.poppins(
  color: HexColor('#DB3F3F'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

//edit profile
TextStyle titleEdit = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
);

TextStyle labelEdit = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle inputEdit = GoogleFonts.poppins(
  color: HexColor('#231F20'),
  fontWeight: FontWeight.w400,
  fontSize: 16.sp,
);

String convertToIdr(dynamic number) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormatter.format(number);
}

//qr scan
TextStyle notFoundScan = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle notFoundSubScan = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle nameScan = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle usernameScan = GoogleFonts.poppins(
  color: Colors.white.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

//group chat
TextStyle nameTitleGroup = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 18.sp,
);

TextStyle nameSubTitleGroup = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle namePersonGroup = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle chatTitleGroup = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.90),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle chatMoneyGroup = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 20.sp,
);

TextStyle chatStatusGreenGroup = GoogleFonts.poppins(
  color: HexColor('#229A35'),
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle chatStatusYellowGroup = GoogleFonts.poppins(
  color: HexColor('#FFA800'),
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

//group chat detail
TextStyle labelDetGroup = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle moneyDetGroup = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 28.sp,
);

TextStyle noteDetGroup = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 15.sp,
);

TextStyle subNoteDetGroup = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle chatStatusGreenDetGroup = GoogleFonts.poppins(
  color: HexColor('#229A35'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle chatStatusYellowDetGroup = GoogleFonts.poppins(
  color: HexColor('#FFA800'),
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

//else pages
TextStyle titleElse = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
);

TextStyle subTitleElse = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

//cupertino alert
TextStyle titleAlert = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle titleActAlert = GoogleFonts.poppins(
  color: buttonMain,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

//splash screen
TextStyle titleSplashh = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 20.sp,
  letterSpacing: 5,
);

TextStyle bySplash = GoogleFonts.poppins(
  color: HexColor('#606060'),
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
  letterSpacing: 5,
);

TextStyle orbitSplash = GoogleFonts.raleway(
  color: buttonMain,
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
  letterSpacing: 3,
);

//notification page
TextStyle labelNotification = GoogleFonts.poppins(
  color: Colors.black.withOpacity(0.60),
  fontWeight: FontWeight.w600,
  fontSize: 16.sp,
);

TextStyle nameNotification = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle dateNotification = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle moneyNotification = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle statusPendingNotification = GoogleFonts.poppins(
  color: HexColor('#FFA800'),
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

//virtucard
TextStyle nameVC = GoogleFonts.roboto(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle dateVC = GoogleFonts.roboto(
  color: Colors.black.withOpacity(0.80),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);

TextStyle moneyVC = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);

TextStyle nameDetVC = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 20.sp,
);

TextStyle moneyDetVC = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 24.sp,
);

TextStyle dateDetVC = GoogleFonts.poppins(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 18.sp,
);
