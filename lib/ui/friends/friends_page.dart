import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/list_friend.dart';
import 'package:marcha_branch/ui/friends/request_friend.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendsPage extends StatelessWidget {
  final List<String> friends;

  const FriendsPage({Key? key, required this.friends}) : super(key: key);

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
          "Friends",
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
                height: 24.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    child: SizedBox(
                      width: 150.w,
                      height: 42.h,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(
                              style: BorderStyle.solid,
                              color: buttonMain,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListFriends(),
                              ));
                        },
                        child: Text(
                          "Your Friends",
                          style: textButtonSuccess,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    child: SizedBox(
                      width: 150.w,
                      height: 42.h,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(
                              style: BorderStyle.solid,
                              color: buttonMain,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestFriend(),
                              ));
                        },
                        child: Text(
                          "Request",
                          style: textButtonSuccess,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Recommended Friends:",
                style: subTitleFriend,
              ),
              SizedBox(
                height: 18.h,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AuthSuccess) {
                    // getFriends(state.user.id);
                    print('INI FRIENDS WOY: $friends');
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: users
                              .where('email', whereNotIn: friends)
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: (snapshot.data!)
                                    .docs
                                    .map(
                                      (e) => ListTile(
                                        contentPadding: EdgeInsets.all(5),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Image.network(
                                            // 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
                                            e['photo'] == null ||
                                                    e['photo'] == ''
                                                ? 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
                                                : '${e['photo']}',
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
                                                '${e['name']}',
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
                                                '${e['email']}',
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
                                            width: 70.w,
                                            height: 36.h,
                                            child: TextButton(
                                              onPressed: () async {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                    title: Text(
                                                      'Add ${e['name']}?',
                                                      style: titleAlert,
                                                    ),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child: Text(
                                                          'Cancel',
                                                          style: titleActAlert,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text(
                                                          'Add',
                                                          style: titleActAlert,
                                                        ),
                                                        onPressed: () async {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Success to add ${e['name']}",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);

                                                          await users
                                                              .doc(
                                                                  state.user.id)
                                                              .collection(
                                                                  'friends')
                                                              .doc(e.id)
                                                              .set({
                                                            'name': e['name'],
                                                            'email': e['email'],
                                                            'photo': e['photo'],
                                                            'isRequest': true,
                                                            'statusRequest':
                                                                true,
                                                            'statusFriend':
                                                                false,
                                                          });

                                                          await users
                                                              .doc(e.id)
                                                              .collection(
                                                                  'friends')
                                                              .doc(
                                                                  state.user.id)
                                                              .set({
                                                            'name':
                                                                state.user.name,
                                                            'email': state
                                                                .user.email,
                                                            'photo': state
                                                                .user.photo,
                                                            'isRequest': false,
                                                            'statusRequest':
                                                                true,
                                                            'statusFriend':
                                                                false,
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }, // context
                                              //     .read<AuthService>()
                                              //
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        buttonMain),
                                              ),
                                              child: Text(
                                                'Add',
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
