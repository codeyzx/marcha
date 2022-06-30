import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/friends/friends_page.dart';
import 'package:marcha_branch/ui/qr/qr_scan.dart';
import 'package:marcha_branch/ui/split_bill/splitBillDetail_page.dart';

class SplitBillPage extends StatefulWidget {
  const SplitBillPage({Key? key}) : super(key: key);

  @override
  _SplitBillPageState createState() => _SplitBillPageState();
}

class _SplitBillPageState extends State<SplitBillPage> {
  List<String> friendName = [];
  List<String> friendID = [];
  List<String> friendEmail = [];
  List<String> friendPhoto = [];
  List<String> friendDeviceToken = [];

  @override
  Widget build(BuildContext context) {
    List<String> friends = [];
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
          "Split Bill",
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
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
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
                  child: friendName.isEmpty
                      ? Column(
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
                                      friends.add(snapshot
                                          .data!.docs[i]['email']
                                          .toString());
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
                                      friends.add(snapshot
                                          .data!.docs[i]['email']
                                          .toString());
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
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                labelText: "Search by Username",
                                labelStyle: searchTxt,
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
                                                CheckboxListTile(
                                                  value: friendName
                                                      .contains(e['name']),
                                                  onChanged: (value) {
                                                    // setState(() {
                                                    //   _checked = value!;
                                                    // });
                                                    _onSelected(
                                                        value!,
                                                        e['name'],
                                                        e.id,
                                                        e['email'],
                                                        e['deviceToken'],
                                                        e['photo'] == '' ||
                                                                e['photo'] ==
                                                                    null
                                                            ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                            : e['photo']);
                                                  },
                                                  title: Text(
                                                    e['name'],
                                                    style: titleName,
                                                  ),
                                                  subtitle: Text(
                                                    e['email'],
                                                    style: username,
                                                  ),
                                                  secondary: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      child: Image.network(
                                                        e['photo'] == '' ||
                                                                e['photo'] ==
                                                                    null
                                                            ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                            : e['photo'],
                                                      )),
                                                  activeColor: buttonMain,
                                                  checkColor: Colors.white,
                                                  shape: CircleBorder(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            borderRadius:
                                                BorderRadius.circular(6.r),
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
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0),
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
                              "Selected (${friendName.length})",
                              style: subTitleText,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 500.w,
                                    height: 90.h,
                                    child: ListView.builder(
                                      itemCount: friendName.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(height: 5.h),
                                                  SizedBox(
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
                                                            child:
                                                                Image.network(
                                                              friendPhoto[
                                                                  index],
                                                              width: 60.w,
                                                              height: 60.h,
                                                            )),
                                                        Text(
                                                          friendName[index],
                                                          style: nameTxt,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          friendName.remove(
                                                              friendName[
                                                                  index]);
                                                          friendID.remove(
                                                              friendID[index]);
                                                          friendEmail.remove(
                                                              friendEmail[
                                                                  index]);
                                                          friendPhoto.remove(
                                                              friendPhoto[
                                                                  index]);
                                                          friendDeviceToken.remove(
                                                              friendDeviceToken[
                                                                  index]);
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/icon-cross.png',
                                                        width: 22.w,
                                                        height: 22.h,
                                                      ))),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
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
                                  onPressed: () {},
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
                                  return Column(
                                    children: (snapshot.data!)
                                        .docs
                                        .map(
                                          (e) => Column(
                                            children: [
                                              CheckboxListTile(
                                                value: friendName
                                                    .contains(e['name']),
                                                onChanged: (value) {
                                                  // setState(() {
                                                  //   _checked = value!;
                                                  // });
                                                  _onSelected(
                                                      value!,
                                                      e['name'],
                                                      e.id,
                                                      e['email'],
                                                      e['deviceToken'],
                                                      e['photo'] == '' ||
                                                              e['photo'] == null
                                                          ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                          : e['photo']);
                                                },
                                                title: Text(
                                                  e['name'],
                                                  style: titleName,
                                                ),
                                                subtitle: Text(
                                                  e['email'],
                                                  style: username,
                                                ),
                                                secondary: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                    child: Image.network(
                                                      e['photo'] == '' ||
                                                              e['photo'] == null
                                                          ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                          : e['photo'],
                                                    )),
                                                activeColor: buttonMain,
                                                checkColor: Colors.white,
                                                shape: CircleBorder(),
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
            },
          ),
        ),
      ),
      bottomSheet: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return Container(
              width: 1.sw,
              height: 70.h,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: HexColor("#9D20FF").withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ]),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 320.w,
                    height: 55.h,
                    child: TextButton(
                      onPressed: () {
                        friendName.isEmpty
                            ? ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text('Pilih minimal 1 teman'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: 100, right: 20, left: 20),
                              ))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SplitBillDetailPage(
                                    friendName: friendName,
                                    friendID: friendID,
                                    friendEmail: friendEmail,
                                    friendPhoto: friendPhoto,
                                    userName: state.user.name,
                                    userID: state.user.id,
                                    userEmail: state.user.email,
                                    userPhoto: state.user.photo,
                                    isGroup: false,
                                    groupID: 'notexist',
                                    friendDeviceToken: friendDeviceToken,
                                  ),
                                ));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonMain),
                      ),
                      child: Text(
                        friendName.isEmpty
                            ? 'Split'
                            : 'Split (${friendName.length})',
                        style: textButton,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  void _onSelected(
    bool selected,
    String name,
    String id,
    String email,
    String deviceToken,
    String picture,
  ) {
    if (selected == true) {
      setState(() {
        friendName.add(name);
        friendID.add(id);
        friendEmail.add(email);
        friendPhoto.add(picture);
        friendDeviceToken.add(deviceToken);
      });
    } else {
      setState(() {
        friendName.remove(name);
        friendID.remove(id);
        friendEmail.remove(email);
        friendPhoto.remove(picture);
        friendDeviceToken.remove(deviceToken);
      });
    }
  }
}
