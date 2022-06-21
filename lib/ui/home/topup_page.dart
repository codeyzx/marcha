import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marcha_branch/api/api_base_helper.dart';
import 'package:marcha_branch/api/api_response.dart';
import 'package:marcha_branch/cubit/topup_bloc.dart';
import 'package:marcha_branch/models/topup.dart';

class TopUpHalaman extends StatefulWidget {
  const TopUpHalaman({Key? key}) : super(key: key);

  @override
  TopUpState createState() => TopUpState();
}

class TopUpState extends State<TopUpHalaman> {
  late TopUpBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TopUpBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TopUp"),
      ),
      body: Container(
        padding: EdgeInsets.all(2.0),
        child: RefreshIndicator(
          onRefresh: () => bloc.fetchList(),
          child: StreamBuilder<ApiResponse<List<TopUp>>>(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Text(snapshot.data!.message,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis);
                    break;
                  case Status.COMPLETED:
                    // return TopUpList(list: snapshot.data!.data);
                    // return TopUpDetail(id: 99, harga: 25000);
                    return TopUpDua();
                    break;
                  case Status.ERROR:
                    return InkWell(
                      child: Text(snapshot.data!.message),
                      onTap: () {
                        bloc.fetchList();
                      },
                    );
                    break;
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

//LIST TopUp
// class TopUpList extends StatelessWidget {
//   final List<TopUp> list;

//   const TopUpList({Key? key, required this.list}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       primary: true,
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       itemCount: list.isEmpty ? 0 : list.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: Card(
//               elevation: 3.0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0)),
//               child: InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute<Null>(
//                         builder: (BuildContext context) {
//                           return TopUpDetail(
//                             id: list[index].id,
//                             harga: list[index].harga,
//                           );
//                         },
//                         fullscreenDialog: true));
//                   },
//                   child: ListTile(
//                     leading: Image(image: AssetImage("assets/images/logo.png")),
//                     subtitle: Text(list[index].harga.toString()),
//                     trailing: Icon(Icons.add_shopping_cart),
//                   ))),
//         );
//       },
//     );
//   }
// }

//DETAIL TopUp
class TopUpDetail extends StatelessWidget {
  TopUpDetail({key, required this.id, required this.harga}) : super(key: key);

  ApiBaseHelper api = ApiBaseHelper();
  final _formKey = GlobalKey<FormState>();

  final int id;
  final int harga;
  String nama = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOP UP'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // tambahkan komponen seperti input field disini
              TextFormField(
                initialValue: id.toString(),
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "ID Paket", icon: Icon(Icons.tag)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ID Paket tidak boleh kosong';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: harga.toString(),
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "Harga Paket", icon: Icon(Icons.attach_money)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harga Paket tidak boleh kosong';
                  }
                  return null;
                },
              ),

              TextFormField(
                onSaved: (String? value) {
                  nama = value!;
                },
                decoration: InputDecoration(
                    hintText: "Masukan Nama Lengkap Anda",
                    labelText: "Nama Lengkap",
                    icon: Icon(Icons.people)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              RaisedButton(
                child: Text(
                  "Order",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var orderId = DateTime.now().millisecondsSinceEpoch;
                    Map data = {
                      "payment_type": "bank_transfer",
                      "bank_transfer": {"bank": "permata"},
                      "transaction_details": {
                        "order_id": orderId.toString(),
                        "gross_amount": harga
                      },
                      "tiket_id": id,
                      "nama": nama
                    };
                    var body = json.encode(data);
                    final response = await api.post(
                        "https://marcha-api-test-production.up.railway.app/order/charge",
                        body);

                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return orderDetail(hasil: response.toString());
                        },
                        fullscreenDialog: true));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//TOP UP 2
class TopUpDua extends StatefulWidget {
  const TopUpDua({Key? key}) : super(key: key);

  @override
  State<TopUpDua> createState() => _TopUpDuaState();
}

class _TopUpDuaState extends State<TopUpDua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deliver to:', style: TextStyle(color: Colors.black)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text('Name', style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text(
                        'widget.transaction.user.name',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text('Phone No.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text(
                        '+6285624918683',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child:
                          Text('Address', style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text(
                        'widget.transaction.user.address',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text('House No.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text(
                        'widget.transaction.user.houseNumber',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text('City', style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Text(
                        'widget.transaction.user.city',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // * Checkout Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: RaisedButton(
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                child: Text(
                  'Checkout Now',
                  style: TextStyle(color: Colors.black).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () async {
                  // setState(() {
                  //   isLoading = true;
                  // });

                  // String paymentURL = await context
                  //     .read<TransactionCubit>()
                  //     .submitTransaction(widget.transaction.copyWith(
                  //         dateTime: DateTime.now(),
                  //         total: widget.transaction.total +
                  //             (widget.transaction.total * 0.1).toInt() +
                  //             50000));

                  // if (paymentURL != null) {
                  //   Get.to(PaymentMethodPage(paymentURL));
                  // } else {
                  //   Get.snackbar(
                  //     '',
                  //     '',
                  //     backgroundColor: 'D9435E'.toColor(),
                  //     icon: Icon(MdiIcons.closeCircleOutline,
                  //         color: Colors.white),
                  //     titleText: Text(
                  //       'Transaction Failed',
                  //       style: GoogleFonts.poppins(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     messageText: Text(
                  //       'Please try again later.',
                  //       style: GoogleFonts.poppins(color: Colors.white),
                  //     ),
                  //   );

                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//HASIL ORDER
class orderDetail extends StatelessWidget {
  const orderDetail({key, required this.hasil}) : super(key: key);

  final String hasil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hasil Order"),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Text(hasil),
          ),
        ));
  }
}
