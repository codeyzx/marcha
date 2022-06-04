import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';

class ListFriends extends StatelessWidget {
  const ListFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    List<String> friends = [];
    return Scaffold(
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
          "Your Friends",
          style: appbarTxt,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
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
                          .where('statusRequest', isEqualTo: false)
                          .snapshots();
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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

                      SizedBox(
                        height: 25.h,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: listFriends,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data!.docs.length);
                            if (snapshot.data!.docs.isNotEmpty) {
                              return Column(
                                children: (snapshot.data!)
                                    .docs
                                    .map(
                                      (e2) => ListTile(
                                        contentPadding: EdgeInsets.all(5),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Image.network(
                                            // 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
                                            e2['photo'] == null ||
                                                    e2['photo'] == ''
                                                ? 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
                                                : '${e2['photo']}',
                                            width: 60.w,
                                            height: 60.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: SizedBox(
                                          width: 150.w,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '${e2['name']}',
                                                // 'Ahmad Joni',
                                                style: titleName,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          width: 150.w,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '${e2['email']}',
                                                // 'Ahmad Joni',
                                                style: username,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                        trailing: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                          child: SizedBox(
                                            width: 75.w,
                                            height: 36.h,
                                            child: TextButton(
                                              onPressed: () async {
                                                // await AuthService()
                                                //     .addNewConnection(e2['email']);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => ChatRoom(),
                                                //     ));

                                                // await users
                                                //     .doc(state
                                                //         .user.id)
                                                //     .collection(
                                                //         'friends')
                                                //     .doc(e.id)
                                                //     .set({
                                                //   'name': e2['name'],
                                                //   'email':
                                                //       e2['email'],
                                                //   'photo':
                                                //       e2['photo'],
                                                //   'statusRequest':
                                                //       true,
                                                //   'statusFriend':
                                                //       false,
                                                // });

                                                // await users
                                                //     .doc(e.id)
                                                //     .collection(
                                                //         'friends')
                                                //     .doc(state
                                                //         .user.id)
                                                //     .set({
                                                //   'name': state
                                                //       .user.name,
                                                //   'email': state
                                                //       .user.email,
                                                //   'photo': '',
                                                //   'statusRequest':
                                                //       true,
                                                //   'statusFriend':
                                                //       false,
                                                // });
                                              }, // context
                                              //     .read<AuthService>()
                                              //     .addNewConnection(e2['email']),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        buttonMain),
                                              ),
                                              child: Text(
                                                'Message',
                                                style: txtButtonFriend,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 115.h,
                                  ),
                                  Image.asset(
                                    'assets/images/group-else-img.png',
                                    width: 240.w,
                                    height: 108.43.h,
                                  ),
                                  SizedBox(
                                    height: 27.h,
                                  ),
                                  Text(
                                    'Belum ada Teman',
                                    style: titleElse,
                                  ),
                                  Text(
                                    'Kirim request pertemanan ke temanmu',
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
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return FriendsPage(
                                                  friends: friends);
                                            }));
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
                    ],
                  );
                } else {
                  return SizedBox();
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
