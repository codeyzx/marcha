// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:midpay/midpay.dart';

// class TopUpLibrary extends StatefulWidget {
//   @override
//   _TopUpLibraryState createState() => _TopUpLibraryState();
// }

// class _TopUpLibraryState extends State<TopUpLibrary> {
//   final midpay = Midpay();

//   //test payment
//   _testPayment() {
//     //for android auto sandbox when debug and production when release
//     midpay.init("SB-Mid-client-ECv28tdH14bLZVkg",
//         "https://marcha-api-test-production.up.railway.app/order/charge",
//         environment: Environment.sanbox);
//     midpay.setFinishCallback(_callback);
//     var midtransCustomer = MidtransCustomer(
//         'Zaki', 'Mubarok', 'kakzaki@gmail.com', '085704703691');
//     List<MidtransItem> listitems = [];
//     var midtransItems = MidtransItem('ID123', 50000, 1, 'TopUp');
//     listitems.add(midtransItems);
//     var midtransTransaction = MidtransTransaction(
//         50000, midtransCustomer, listitems,
//         skipCustomer: true);
//     midpay
//         .makePayment(midtransTransaction)
//         .catchError((err) => print("ERROR $err"));
//   }

//   //calback
//   Future<void> _callback(TransactionFinished finished) async {
//     print("Finish $finished");
//     return Future.value(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Midpay Plugin example app'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             child: Text("Payment"),
//             onPressed: () => _testPayment(),
//           ),
//         ),
//       ),
//     );
//   }
// }
