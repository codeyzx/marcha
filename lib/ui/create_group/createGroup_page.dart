import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/create_group/createGroupDetail_page.dart';
import 'package:marcha_branch/ui/groups/group_add.dart';
import 'package:marcha_branch/ui/groups/group_success_page.dart';

class CreateGroupPage extends StatefulWidget {
  final bool isAdd;
  final String groupID;
  final List members;
  final List membersEmail;
  final List membersName;
  const CreateGroupPage({
    Key? key,
    required this.isAdd,
    required this.groupID,
    required this.members,
    required this.membersName,
    required this.membersEmail,
  }) : super(key: key);

  @override
  _CreateGroupPageState createState() =>
      _CreateGroupPageState(isAdd, groupID, members, membersName, membersEmail);
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final bool _isAdd;
  final String _groupID;
  final List _members;
  final List _membersEmail;
  final List _membersName;

  _CreateGroupPageState(this._isAdd, this._groupID, this._members,
      this._membersName, this._membersEmail);

  List<String> friendName = [];
  List<String> friendID = [];
  List<String> friendEmail = [];
  List<String> friendPhoto = [];

  @override
  Widget build(BuildContext context) {
    return _isAdd
        ? Scaffold(
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
                "Add Friends to Group",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AuthSuccess) {
                        // Stream<QuerySnapshot<Map<String, dynamic>>>
                        //     listFriends = FirebaseFirestore.instance
                        //         .collection('users')
                        //         .doc(state.user.id)
                        //         .collection('friends')
                        //         // .where('statusFriend', isEqualTo: true)
                        //         .where('email', whereNotIn: _members)
                        //         .where('statusFriend', isEqualTo: true)
                        //         .snapshots();
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
                          child: friendName.isEmpty
                              ? Column(
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
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        labelText: "Search by Username",
                                        labelStyle: searchTxt,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  builder: (context) =>
                                                      GroupAdd(),
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
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(state.user.id)
                                          .collection('friends')
                                          // .where('statusFriend', isEqualTo: true)
                                          .where('email', whereNotIn: _members)
                                          .where('statusFriend',
                                              isEqualTo: true)
                                          .snapshots(),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children:
                                                (snapshot.data!).docs.map((e) {
                                              print('JUMLAH NYA ${e.data()}');
                                              return Column(
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
                                                            BorderRadius
                                                                .circular(15.r),
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
                                              );
                                            }).toList(),
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
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
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
                                              itemBuilder:
                                                  (context, int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                        BorderRadius.circular(15
                                                                            .r),
                                                                    child: Image
                                                                        .network(
                                                                      friendPhoto[
                                                                          index],
                                                                      width:
                                                                          60.w,
                                                                      height:
                                                                          60.h,
                                                                    )),
                                                                Text(
                                                                  friendName[
                                                                      index],
                                                                  style:
                                                                      nameTxt,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  friendName.remove(
                                                                      friendName[
                                                                          index]);
                                                                  friendID.remove(
                                                                      friendID[
                                                                          index]);
                                                                  friendEmail.remove(
                                                                      friendEmail[
                                                                          index]);
                                                                  friendPhoto.remove(
                                                                      friendPhoto[
                                                                          index]);
                                                                });
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(state.user.id)
                                          .collection('friends')
                                          // .where('statusFriend', isEqualTo: true)
                                          // .where('email', whereNotIn: _members)
                                          .where('statusFriend',
                                              isEqualTo: true)
                                          .snapshots(),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: (snapshot.data!)
                                                .docs
                                                .map(
                                                  (e) => Column(
                                                    children: [
                                                      CheckboxListTile(
                                                        value:
                                                            friendName.contains(
                                                                e['name']),
                                                        onChanged: (value) {
                                                          // setState(() {
                                                          //   _checked = value!;
                                                          // });
                                                          _onSelected(
                                                              value!,
                                                              e['name'],
                                                              e.id,
                                                              e['email'],
                                                              e['photo'] ==
                                                                          '' ||
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
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                          child: Image.network(
                                                            e['photo'] == '' ||
                                                                    e['photo'] ==
                                                                        null
                                                                ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                                : e['photo'],
                                                            width: 60.w,
                                                            height: 60.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        activeColor: buttonMain,
                                                        checkColor:
                                                            Colors.white,
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
                ],
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
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
                            onPressed: friendName.isEmpty
                                ? () {
                                    ScaffoldMessenger.of(context)
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
                                    ));
                                  }
                                : () async {
                                    Map<String, dynamic> data = {};

                                    for (var i = 0; i < _members.length; i++) {
                                      friendEmail.add(_membersEmail[i]);
                                      friendName.add(_membersName[i]);
                                    }

                                    friendEmail.add(state.user.email);
                                    friendName.add(state.user.name);

                                    data['membersEmail'] = friendEmail;
                                    data['membersName'] = friendName;
                                    await FirebaseFirestore.instance
                                        .collection('groups')
                                        .doc(_groupID)
                                        .update(data);

                                    for (var i = 0; i < friendID.length; i++) {
                                      await FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(_groupID)
                                          .collection('member')
                                          .doc(friendID[i])
                                          .set({
                                        'id': friendID[i],
                                        'name': friendName[i],
                                        'email': friendEmail[i],
                                        'photo': friendPhoto[i],
                                      });
                                    }

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupSuccessPage(isAdd: true),
                                        ));
                                  },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonMain),
                            ),
                            child: Text(
                              'Tambahkan',
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
          )
        : Scaffold(
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
                "Create New Group",
                style: appbarTxt,
              ),
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AuthSuccess) {
                        Stream<QuerySnapshot<Map<String, dynamic>>>
                            listFriends = FirebaseFirestore.instance
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
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        labelText: "Search by Username",
                                        labelStyle: searchTxt,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  builder: (context) =>
                                                      GroupAdd(),
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
                                          return Column(
                                            children: (snapshot.data!)
                                                .docs
                                                .map(
                                                  (e) => Column(
                                                    children: [
                                                      CheckboxListTile(
                                                        value:
                                                            friendName.contains(
                                                                e['name']),
                                                        onChanged: (value) {
                                                          // setState(() {
                                                          //   _checked = value!;
                                                          // });
                                                          _onSelected(
                                                              value!,
                                                              e['name'],
                                                              e.id,
                                                              e['email'],
                                                              e['photo'] ==
                                                                          '' ||
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
                                                                BorderRadius
                                                                    .circular(
                                                                        15.r),
                                                            child:
                                                                Image.network(
                                                              e['photo'] ==
                                                                          '' ||
                                                                      e['photo'] ==
                                                                          null
                                                                  ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                                  : e['photo'],
                                                            )),
                                                        activeColor: buttonMain,
                                                        checkColor:
                                                            Colors.white,
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
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
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
                                              itemBuilder:
                                                  (context, int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                        BorderRadius.circular(15
                                                                            .r),
                                                                    child: Image
                                                                        .network(
                                                                      friendPhoto[
                                                                          index],
                                                                      width:
                                                                          60.w,
                                                                      height:
                                                                          60.h,
                                                                    )),
                                                                Text(
                                                                  friendName[
                                                                      index],
                                                                  style:
                                                                      nameTxt,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  friendName.remove(
                                                                      friendName[
                                                                          index]);
                                                                  friendID.remove(
                                                                      friendID[
                                                                          index]);
                                                                  friendEmail.remove(
                                                                      friendEmail[
                                                                          index]);
                                                                  friendPhoto.remove(
                                                                      friendPhoto[
                                                                          index]);
                                                                });
                                                              },
                                                              child:
                                                                  Image.asset(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                        value:
                                                            friendName.contains(
                                                                e['name']),
                                                        onChanged: (value) {
                                                          // setState(() {
                                                          //   _checked = value!;
                                                          // });
                                                          _onSelected(
                                                              value!,
                                                              e['name'],
                                                              e.id,
                                                              e['email'],
                                                              e['photo'] ==
                                                                          '' ||
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
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                          child: Image.network(
                                                            e['photo'] == '' ||
                                                                    e['photo'] ==
                                                                        null
                                                                ? "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg"
                                                                : e['photo'],
                                                            width: 60.w,
                                                            height: 60.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        activeColor: buttonMain,
                                                        checkColor:
                                                            Colors.white,
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
                ],
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
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
                                        builder: (context) =>
                                            CreateGroupDetailPage(
                                          friendName: friendName,
                                          friendID: friendID,
                                          friendEmail: friendEmail,
                                          friendPhoto: friendPhoto,
                                          userName: state.user.name,
                                          userID: state.user.id,
                                          userEmail: state.user.email,
                                          userPhoto: state.user.photo,
                                        ),
                                      ));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonMain),
                            ),
                            child: Text(
                              'Selanjutnya',
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
    String picture,
  ) {
    if (selected == true) {
      setState(() {
        friendName.add(name);
        friendID.add(id);
        friendEmail.add(email);
        friendPhoto.add(picture);
      });
    } else {
      setState(() {
        friendName.remove(name);
        friendID.remove(id);
        friendEmail.remove(email);
        friendPhoto.remove(picture);
      });
    }
  }
}
