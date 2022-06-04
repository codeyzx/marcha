import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';
import 'package:marcha_branch/ui/qr/qr_scan.dart';
import 'package:marcha_branch/ui/send/sendDetail_page.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    List<String> friends = [];
    CollectionReference send = FirebaseFirestore.instance.collection('send');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: HexColor("#F8F6FF"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: buttonMain,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Send",
          style: appbarTxt,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScan(),
                  ));
            },
            icon: Image.asset('assets/images/icon_scan.png'),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AuthSuccess) {
                friends.add(state.user.email);
                Stream<QuerySnapshot<Map<String, dynamic>>> listFriends =
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(state.user.id)
                        .collection('friends')
                        .where('statusFriend', isEqualTo: true)
                        .snapshots();
                return Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // State punya temen
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .doc(state.user.id)
                            .collection('friends')
                            .where('statusFriend', isEqualTo: true)
                            .where('statusRequest', isEqualTo: false)
                            // .where(
                            //     'statusRequest',
                            //     isEqualTo:
                            //         false)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            print('SNAPSHOT CENAH');
                            if (snapshot.data!.docs.isNotEmpty) {
                              var okedek = snapshot.data!.docs.length;

                              for (var i = 0; i < okedek; i++) {
                                // lee.add(snapshot.data!.docs[i]['email']);
                                friends.add(
                                    snapshot.data!.docs[i]['email'].toString());
                              }
                              // friends.add(state.user.email);
                            }
                            return SizedBox();
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      // State punya request
                      StreamBuilder<QuerySnapshot>(
                        stream: users
                            .doc(state.user.id)
                            .collection('friends')
                            .where('statusFriend', isEqualTo: false)
                            .where('statusRequest', isEqualTo: true)
                            // .where(
                            //     'statusRequest',
                            //     isEqualTo:
                            //         false)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            print('SNAPSHOT CENAH');
                            if (snapshot.data!.docs.isNotEmpty) {
                              var okedek = snapshot.data!.docs.length;

                              for (var i = 0; i < okedek; i++) {
                                // lee.add(snapshot.data!.docs[i]['email']);
                                friends.add(
                                    snapshot.data!.docs[i]['email'].toString());
                              }
                              // friends.add(state.user.email);
                            }
                            return SizedBox();
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('EBEDEE'),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search_rounded),
                            onPressed: () {},
                          ),
                          iconColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          labelText: "Search by Username",
                          labelStyle: searchTxt,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Text(
                        "Recents",
                        style: subTitleText,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: send
                                  .where('userSendEmail',
                                      isEqualTo: state.user.email)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: (snapshot.data!)
                                        .docs
                                        .map(
                                          (e) => Row(
                                            children: [
                                              InkWell(
                                                onTap: () {},
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
                                                          child: Image.network(
                                                            e['userTargetPhoto'] ==
                                                                        '' ||
                                                                    e['userTargetPhoto'] ==
                                                                        null
                                                                // ? "https://lh3.googleusercontent.com/a-/AOh14GhnbB6AM4Wd8k0YX3ioVbezlujkoYYUtL-XZwuaqA=s96-c"
                                                                // ? 'https://pbs.twimg.com/profile_images/1377122285606240269/TQb7Mtr7_400x400.jpg'
                                                                ? 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg'
                                                                : e['userTargetPhoto'],
                                                            width: 60.w,
                                                            height: 60.h,
                                                            fit: BoxFit.contain,
                                                          )),
                                                      Text(
                                                        e['userTargetName'],
                                                        style: nameTxt,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30.w,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "All",
                            style: subTitleText,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendsPage(
                                      friends: friends,
                                    ),
                                  ));
                            },
                            child: Text(
                              "Add New (+)",
                              style: addText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: listFriends,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isNotEmpty) {
                              return Column(
                                children: (snapshot.data!)
                                    .docs
                                    .map(
                                      (e) => Column(
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SendDetail(
                                                    userSendID: state.user.id,
                                                    userSendEmail:
                                                        state.user.email,
                                                    userSendName:
                                                        state.user.name,
                                                    userSendPhoto:
                                                        state.user.photo,
                                                    userTargetID: e.id,
                                                    userTargetEmail: e['email'],
                                                    userTargetName: e['name'],
                                                    userTargetPhoto: e[
                                                                'photo'] ==
                                                            ''
                                                        ? 'https://static.wikia.nocookie.net/shipping/images/0/07/ScarfKasa.png/revision/latest?cb=20210801201824'
                                                        : e['photo'],
                                                  ),
                                                )),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                    child: Image.network(
                                                      e['photo'] == ''
                                                          ? 'https://static.wikia.nocookie.net/shipping/images/0/07/ScarfKasa.png/revision/latest?cb=20210801201824'
                                                          : e['photo'],
                                                      width: 60.w,
                                                      height: 60.h,
                                                    )),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 245.w,
                                                        child: Text(
                                                          e['name'],
                                                          style: titleName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        )),
                                                    SizedBox(
                                                        width: 245.w,
                                                        child: Text(
                                                          e['email'],
                                                          style: username,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18.h,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  Image.asset(
                                    'assets/images/group-else-img.png',
                                    width: 240.w,
                                    height: 108.43.h,
                                  ),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  Text(
                                    'Belum ada Teman',
                                    style: titleElse,
                                  ),
                                  Text(
                                    'Kamu perlu teman untuk lakukan transaksi',
                                    style: subTitleElse,
                                  ),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.r),
                                      child: SizedBox(
                                        width: 180.w,
                                        height: 46.h,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FriendsPage(
                                                    friends: friends,
                                                  ),
                                                ));
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    buttonMain),
                                          ),
                                          child: Text(
                                            'Cari Teman',
                                            style: textButton,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
