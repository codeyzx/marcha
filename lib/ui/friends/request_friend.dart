import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestFriend extends StatelessWidget {
  const RequestFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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
          "Friends Request",
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
                  Stream<QuerySnapshot<Map<String, dynamic>>> requestFriend =
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(state.user.id)
                          .collection('friends')
                          .where('statusFriend', isEqualTo: false)
                          .where('isRequest', isEqualTo: false)
                          .where('statusRequest', isEqualTo: true)
                          .snapshots();
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: requestFriend,
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
                                          width: 89.w,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${e2['name']}',
                                              // 'Ahmad Joni',
                                              style: titleName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          width: 89.w,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${e2['email']}',
                                              // 'Ahmad Joni',
                                              style: username,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        trailing: Wrap(
                                          spacing:
                                              10, // space between two icons
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3.r),
                                              child: SizedBox(
                                                width: 65.w,
                                                height: 36.h,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await users
                                                        .doc(state.user.id)
                                                        .collection('friends')
                                                        .doc(e2.id)
                                                        .update({
                                                      'isRequest': false,
                                                      'statusRequest': false,
                                                      'statusFriend': true,
                                                    });

                                                    await users
                                                        .doc(e2.id)
                                                        .collection('friends')
                                                        .doc(state.user.id)
                                                        .update({
                                                      'isRequest': false,
                                                      'statusRequest': false,
                                                      'statusFriend': true,
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(buttonMain),
                                                  ),
                                                  child: Text(
                                                    'Accept',
                                                    style: txtButtonFriend,
                                                  ),
                                                ),
                                              ),
                                            ), // icon-2
                                            ClipRRect(
                                              child: SizedBox(
                                                width: 70.w,
                                                height: 36.h,
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                      ),
                                                    ),
                                                    side: MaterialStateProperty
                                                        .all(
                                                      BorderSide(
                                                        style:
                                                            BorderStyle.solid,
                                                        color: buttonMain,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await users
                                                        .doc(state.user.id)
                                                        .collection('friends')
                                                        .doc(e2.id)
                                                        .update({
                                                      'isRequest': false,
                                                      'statusRequest': false,
                                                      'statusFriend': false,
                                                    });

                                                    await users
                                                        .doc(e2.id)
                                                        .collection('friends')
                                                        .doc(state.user.id)
                                                        .update({
                                                      'isRequest': false,
                                                      'statusRequest': false,
                                                      'statusFriend': false,
                                                    });
                                                  },
                                                  child: Text(
                                                    "Reject",
                                                    style: txtButtonWhiteFriend,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                    'Belum ada Request ',
                                    style: titleElse,
                                  ),
                                  Text(
                                    'Minta temanmu untuk request friends',
                                    style: subTitleElse,
                                  ),
                                  SizedBox(
                                    height: 18.h,
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
