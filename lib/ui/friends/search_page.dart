import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/models/user_model.dart';
import 'package:marcha_branch/services/auth_service.dart';
import 'package:marcha_branch/ui/friends/chat_room.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  User? currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userMap;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  var queryAwal = [].obs;
  var tempSearch = [].obs;

  void onSearch(String data) async {
    Query<Map<String, dynamic>> users = _firestore
        .collection('users')
        .where('email', isNotEqualTo: currUser!.email);
    print('SEARCH : $data');
    if (data.isEmpty) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      // var capitaliezd = data.substring(0, 1).toUpperCase() + data.substring(1);
      // if (queryAwal.isEmpty && data.length == 1) {
      //   final keyNameResult = await users
      //       .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
      //       .get();

      //   print('TOTAL DATA : ${keyNameResult.docs.length}');

      //   if (keyNameResult.docs.isNotEmpty) {
      //     for (int i = 0; i < keyNameResult.docs.length; i++) {
      //       queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
      //     }
      //     print('QUERY RESULT : ');
      //     print(queryAwal);
      //   } else {
      //     print('TIDAK ADA DATA');
      //   }
      // }
      // if (queryAwal.isNotEmpty) {
      //   tempSearch.value = [];
      //   for (var element in queryAwal) {
      //     if (element['name'].startsWith(capitaliezd)) {
      //       tempSearch.add(element);
      //     }
      //   }
      // }

      var capitaliezd = data.toUpperCase();

      if (queryAwal.isEmpty && data.length == 1) {
        print('=========== QUERY AWAL IS EMPTY & DATA CUMA 1');
        print(data);
        final keyNameResult = await users.get();
        print('TOTAL DATA : ${keyNameResult.docs.length}');

        // if (keyNameResult.docs.isNotEmpty) {
        //   print('=========== KEYNAMERESULT IS TRUE');
        for (int i = 0; i < keyNameResult.docs.length; i++) {
          queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
        }
        //   print('QUERY RESULT : ');
        //   print(queryAwal);
        // } else {
        //   print('TIDAK ADA DATA');
        // }
      }
      tempSearch.value = [];
      for (var element in queryAwal) {
        var capEl = element['name'].toUpperCase();
        if (capEl.startsWith(capitaliezd)) {
          tempSearch.add(element);
        }
      }
      // if (queryAwal.isNotEmpty) {
      //   print('=========== QUERY AWAL IS NOT EMPTY');
      //   tempSearch.value = [];
      //   for (var element in queryAwal) {
      //     var capEl = element['name'].toUpperCase();
      //     if (capEl.startsWith(capitaliezd)) {
      //       tempSearch.add(element);
      //     }
      //   }
      // }
    }

    queryAwal.refresh();
    tempSearch.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context2) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: AppBar(
            title: Text('Search'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onChanged: (value) => onSearch(value),
                  controller: _search,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1)),
                      hintText: 'Search new friend here..',
                      contentPadding: EdgeInsets.symmetric(horizontal: 30)),
                ),
              ),
            ),
          ),

          // PreferredSize(
          //   child: AppBar(
          //     leading: IconButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         icon: Icon(
          //           Icons.arrow_back_rounded,
          //           color: HexColor("#39A2DB"),
          //         )),
          //     elevation: 0,
          //     backgroundColor: Colors.white,
          //     flexibleSpace: Padding(
          //       padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 20.h),
          //       child: Align(
          //         alignment: Alignment.bottomCenter,
          //         child: TextField(
          //           onChanged: (value) => onSearch(value),
          //           controller: _search,
          //           cursorColor: Colors.white,
          //           style: GoogleFonts.poppins(
          //             fontSize: 14.sp,
          //             color: Colors.white,
          //           ),
          //           decoration: InputDecoration(
          //             fillColor: HexColor("#39A2DB"),
          //             filled: true,
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(30.r),
          //               borderSide: BorderSide(
          //                 color: Colors.white,
          //                 width: 1,
          //               ),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(50.r),
          //               borderSide: BorderSide(
          //                 color: Colors.white,
          //                 width: 1,
          //               ),
          //             ),
          //             hintText: "Cari users..",
          //             hintStyle: GoogleFonts.poppins(
          //               fontSize: 14.sp,
          //               color: Colors.white,
          //             ),
          //             contentPadding: EdgeInsets.symmetric(
          //               horizontal: 30.w,
          //               vertical: 20.h,
          //             ),
          //             suffixIcon: InkWell(
          //               borderRadius: BorderRadius.circular(50.r),
          //               onTap: () {},
          //               child: Icon(
          //                 Icons.search,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //   preferredSize: const Size.fromHeight(140),
          // ),
        ),
        body: Obx(() => tempSearch.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 100.h),
                      height: 200.h,
                      width: 200.w,
                      child: Image.network(
                          'https://i.pinimg.com/474x/8e/24/6a/8e246a0805454d4a8b467bfc76727c58.jpg'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 30.h, left: 8.w, right: 8.w, bottom: 3.h),
                      child: Text(
                        "Find your friend!",
                        style: GoogleFonts.poppins(
                            fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "made with Flader",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tempSearch.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context2,
                    //     MaterialPageRoute(
                    //         builder: (context) => BookPage(
                    //               tempSearch[index]['id'].toString(),
                    //               tempSearch[index]['image'],
                    //               tempSearch[index]['judul'],
                    //               tempSearch[index]['jumlahHalaman'],
                    //               tempSearch[index]['stok'],
                    //               tempSearch[index]['isKonvensional'],
                    //               tempSearch[index]['penulis'],
                    //               tempSearch[index]['sinopsis'],
                    //               tempSearch[index]['ebook'],
                    //             )));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black26,
                      child: Image.network(
                        tempSearch[index]['photo'] == null ||
                                tempSearch[index]['photo'] == ''
                            // ? 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
                            ? 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1031&q=80'
                            : '${tempSearch[index]['photo']}',
                      ),
                    ),
                    title: Text(
                      '${tempSearch[index]['name']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${tempSearch[index]['email']}',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                        // await AuthService()
                        //     .addNewConnection(tempSearch[index]['email']);
                        bool flagNewConnection = false;
                        String chatID;
                        String date = DateTime.now().toIso8601String();
                        CollectionReference chats =
                            firestore.collection('chats');
                        CollectionReference users =
                            firestore.collection('users');
                        final checkConnection = await users
                            .doc(currUser!.uid)
                            .collection('chats')
                            .where('connection',
                                isEqualTo: tempSearch[index]['email'])
                            .get();

                        final docChats = await users
                            .doc(currUser!.uid)
                            .collection('chats')
                            .get();

                        if (docChats.docs.isNotEmpty) {
                          print(
                              'USER PUNYA DOC CHAT: \n ${docChats.docs.length}');
                          // user have chat with anyone

                          if (checkConnection.docs.isNotEmpty) {
                            print(
                                'USER PERNAH CHATAN DENGAN TEMAN: \n ${docChats.docs.length}');
                            flagNewConnection = false;
                            chatID = checkConnection.docs[0].id; //chatID
                            print('CHAT ID: $chatID');
                          } else {
                            flagNewConnection = true;
                          }
                        } else {
                          print(
                              'USER TIDAK PERNAH CHATAN DENGAN TEMAN: \n ${docChats.docs.length}');
                          flagNewConnection = true;
                        }

                        if (flagNewConnection) {
                          final chatsDocs =
                              await chats.where('connections', whereIn: [
                            [
                              currUser!.email,
                              tempSearch[index]['email'],
                            ],
                            [
                              tempSearch[index]['email'],
                              currUser!.email,
                            ]
                          ]).get();

                          if (chatsDocs.docs.isNotEmpty) {
                            print(
                                'FLAG-USER PERNAH CHATAN DENGAN TEMAN: \n ${chatsDocs.docs.length}');
                            final chatDataId = chatsDocs.docs[0].id;
                            final chatsData = chatsDocs.docs[0].data()
                                as Map<String, dynamic>;

                            print('CHAT DOCS ID : $chatDataId');

                            await users
                                .doc(currUser!.uid)
                                .collection('chats')
                                .doc(chatDataId)
                                .set({
                              'connection': tempSearch[index]['email'],
                              'lastTime': chatsData['lastTime'],
                              'total_unread': 0,
                            });

                            final listChats = await users
                                .doc(currUser!.uid)
                                .collection('chats')
                                .get();

                            if (listChats.docs.isNotEmpty) {
                              List<ChatUser> dataListChats = [];
                              for (var element in listChats.docs) {
                                var dataDocChat = element.data();
                                var dataDocChatId = element.id;
                                dataListChats.add(ChatUser(
                                  connection: dataDocChat['connection'],
                                  chatId: dataDocChatId,
                                  // lastTime: dataDocChat['lastTime'],
                                  lastTime: date,
                                  totalUnread: 0,
                                  // totalUnread: dataDocChat['totalUnread'],
                                ));
                              }
                            }
                          } else {
                            print(
                                'FLAG-USER TIDAK PERNAH CHATAN DENGAN TEMAN: \n ${chatsDocs.docs.length}');
                            final newChatDoc = await chats.add({
                              'connections': [
                                currUser!.email,
                                tempSearch[index]['email'],
                              ],
                            });

                            chats.doc(newChatDoc.id).collection('chats');

                            await users
                                .doc(currUser!.uid)
                                .collection('chats')
                                .doc(newChatDoc.id)
                                .set({
                              'connection': tempSearch[index]['email'],
                              'lastTime': date,
                              'total_unread': 0,
                            });

                            final listChats = await users
                                .doc(currUser!.uid)
                                .collection('chats')
                                .get();

                            if (listChats.docs.isNotEmpty) {
                              List<ChatUser> dataListChats = [];
                              for (var element in listChats.docs) {
                                var dataDocChat = element.data();
                                var dataDocChatId = element.id;
                                dataListChats.add(ChatUser(
                                    connection: dataDocChat['connection'],
                                    chatId: dataDocChatId,
                                    lastTime: dataDocChat['lastTime'],
                                    totalUnread: 0));
                              }
                            }
                          }
                        }

                        chatID = checkConnection.docs[0].id;

                        final updateStatusChat = await chats
                            .doc(chatID)
                            .collection('chat')
                            .where('isRead', isEqualTo: false)
                            .where('penerima', isEqualTo: currUser!.email)
                            .get();

                        updateStatusChat.docs.forEach((element) async {
                          await chats
                              .doc(chatID)
                              .collection('chat')
                              .doc(element.id)
                              .update({'isRead': true});
                        });

                        await users
                            .doc(currUser!.uid)
                            .collection('chats')
                            .doc(chatID)
                            .update({'total_unread': 0});

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                  penerima: tempSearch[index]['email'],
                                  penerimaID: tempSearch[index].id,
                                  chatID: chatID,
                                  pengirim: currUser!.email!,
                                  pengirimID: currUser!.uid),
                              // ChatRoom(
                              //   penerima: tempSearch[index]['email'],
                              //   pengirim: currUser!.email!,
                              //   pengirimID: currUser!.uid,
                              //   chatID: checkConnection.docs[0].id,
                              // ),
                            ));
                      }, // context
                      //     .read<AuthService>()
                      //     .addNewConnection(tempSearch[index]['email']),
                      child: Chip(
                        label: Text('Message'),
                      ),
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
