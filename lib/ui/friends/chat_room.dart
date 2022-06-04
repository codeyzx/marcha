
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/shared/theme.dart';

class ChatRoom extends StatefulWidget {
  final String penerima;
  final String penerimaID;
  final String pengirim;
  final String pengirimID;
  final String chatID;
  const ChatRoom({
    Key? key,
    required this.penerima,
    required this.penerimaID,
    required this.chatID,
    required this.pengirim,
    required this.pengirimID,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() =>
      _ChatRoomState(penerima, penerimaID, pengirim, pengirimID, chatID);
}

class _ChatRoomState extends State<ChatRoom> {
  final String _penerima;
  final String _penerimaID;
  final String _pengirim;
  final String _pengirimID;
  final String _chatID;

  _ChatRoomState(this._penerima, this._penerimaID, this._pengirim,
      this._pengirimID, this._chatID);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _note = TextEditingController();
    final String date = DateTime.now().toIso8601String();
    int total_unread;
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('CHAT ROOM')),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      'TEST CHATING DARI USER 1',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => makeDismissible(
            child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                builder: (_, controller) => Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: HexColor("#F6F6F6"),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.r)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 41),
                          Center(
                            child: Container(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Note *',
                                    hintText: 'Tambahkan Pesan'),
                                controller: _note,
                              ),
                              padding: EdgeInsets.all(30),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 320.w,
                              height: 55.h,
                              child: TextButton(
                                onPressed: () async {
                                  final newChat = await chats
                                      .doc(_chatID)
                                      .collection('chat')
                                      .add({
                                    'isRead': false,
                                    'msg': _note.text,
                                    'penerima': _penerima,
                                    'pengirim': _pengirim,
                                    'time': date,
                                  });

                                  await users
                                      .doc(_pengirimID)
                                      .collection('chats')
                                      .doc(_chatID)
                                      .update({
                                    'lastTime': date,
                                  });

                                  final checkChatsFriend = await users
                                      .doc(_penerimaID)
                                      .collection('chats')
                                      .doc(_chatID)
                                      .get();

                                  if (checkChatsFriend.exists) {
                                    final checkTotalUnread = await chats
                                        .doc(_chatID)
                                        .collection('chat')
                                        .where('isRead', isEqualTo: false)
                                        .where('pengirim', isEqualTo: _pengirim)
                                        .get();
                                        
                                    total_unread = checkTotalUnread.docs.length;

                                    await users
                                        .doc(_penerimaID)
                                        .collection('chats')
                                        .doc(_chatID)
                                        .update({
                                      'lastTime': date,
                                      'total_unread': total_unread,
                                    });
                                    
                                  } else {
                                    await users
                                        .doc(_penerimaID)
                                        .collection('chats')
                                        .doc(_chatID)
                                        .set({
                                      'connection': [
                                    _pengirim,
                                    _penerima,
                                  ],
                                      'lastTime': date,
                                      'total_unread': 1,
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(buttonMain),
                                ),
                                child: Text(
                                  'Konfirmasi',
                                  style: textButton,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.r),
            ),
          ),
        );
      }),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}