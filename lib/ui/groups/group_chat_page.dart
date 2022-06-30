import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/create_group/createGroup_page.dart';
import 'package:marcha_branch/ui/groups/group_chat_detail_page.dart';
import 'package:marcha_branch/ui/split_bill/splitBillDetail_page.dart';

class GroupChatPage extends StatefulWidget {
  final String groupID;
  final String email;
  const GroupChatPage({Key? key, required this.groupID, required this.email})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _GroupChatPageState createState() => _GroupChatPageState(groupID, email);
}

class _GroupChatPageState extends State<GroupChatPage> {
  final String _groupID;
  final String _email;

  _GroupChatPageState(this._groupID, this._email);
  @override
  Widget build(BuildContext context) {
    final List<String> friendName = [];
    final List<String> friendID = [];
    final List<String> friendEmail = [];
    final List<String> friendPhoto = [];
    List members = [];
    List membersName = [];
    List membersEmail = [];
    String? userName;
    String? userEmail;
    String? userPhoto;
    String? userID;

    var groupsCollection = FirebaseFirestore.instance
        .collection('groups')
        .doc(_groupID)
        .snapshots();

    return Scaffold(
      backgroundColor: HexColor('#F8F6FF'),
      appBar: AppBar(
        toolbarHeight: 75.h,
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
        flexibleSpace: SafeArea(
          child: Center(
            child: Container(
              width: 213.w,
              height: 55.h,
              color: buttonMain,
              child: StreamBuilder<DocumentSnapshot>(
                stream: groupsCollection,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    members = snapshot.data!['membersEmail'];
                    membersEmail = snapshot.data!['membersEmail'];
                    membersName = snapshot.data!['membersName'];
                    members.removeWhere(
                      (element) => element == _email,
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.network(
                              snapshot.data!['photo'],
                              // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                              width: 40.w,
                              height: 40.h,
                            )),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 160.w,
                                child: Text(
                                  // 'Badminton Az',
                                  snapshot.data!['name'],
                                  style: nameTitleGroup,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            SizedBox(
                                width: 160.w,
                                child: Text(
                                  // 'You, @joni, @emirrrrrrrrrrrrrrrrrrrrr',
                                  // 'You, ${members.join(',').split('@gmail.com').join(',')}',
                                  members
                                      .join('')
                                      .split('@gmail.com')
                                      .join(','),
                                  style: nameSubTitleGroup,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateGroupPage(
                            isAdd: true,
                            groupID: _groupID,
                            members: members,
                            membersEmail: membersEmail,
                            membersName: membersName,
                          )));
            },
            icon: Image.asset('assets/images/add-gchat-icon.png'),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            userName = state.user.name;
            userEmail = state.user.email;
            userPhoto = state.user.photo;
            userID = state.user.id;

            CollectionReference memberGroup = FirebaseFirestore.instance
                .collection('groups')
                .doc(_groupID)
                .collection('member');

            CollectionReference paymentGroup = FirebaseFirestore.instance
                .collection('groups')
                .doc(_groupID)
                .collection('payment');

            return Container(
              // width: 1.sw,
              // height: 1.sh,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: HexColor("#9D20FF").withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ]),
              child: Padding(
                padding: EdgeInsets.only(bottom: 70.h),
                child: ListView(
                  children: [
                    // Stream untuk ngambil data
                    StreamBuilder<QuerySnapshot>(
                      stream: memberGroup
                          .where('id', isNotEqualTo: state.user.id)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                              // shrinkWrap: true,
                              children: snapshot.data!.docs.map((e) {
                            friendName.add(e['name']);
                            friendID.add(e.id);
                            friendEmail.add(e['email']);
                            friendPhoto.add(e['photo']);
                            print(friendName);
                            return SizedBox();
                          }).toList());
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),

                    // Stream nampilin chat
                    SingleChildScrollView(
                      // physics: ScrollPhysics(),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: paymentGroup
                            .where('members', arrayContains: state.user.id)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                // shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((e) => StreamBuilder<QuerySnapshot>(
                                          stream: paymentGroup
                                              .doc(e.id)
                                              .collection('member')
                                              .where('id',
                                                  isEqualTo: state.user.id)
                                              // .where('status', isEqualTo: false)
                                              .snapshots(),
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData) {
                                              return Column(
                                                  // shrinkWrap: true,
                                                  children: snapshot.data!.docs
                                                      .map((e2) => Column(
                                                            children: [
                                                              //chat kiri dari user lain
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20.w),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          25.h,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7.r),
                                                                          child:
                                                                              Image.network(
                                                                            e['photo'],
                                                                            // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                                                            width:
                                                                                30.w,
                                                                            height:
                                                                                30.h,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.w,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              e['name'],
                                                                              // 'Samuel',
                                                                              style: namePersonGroup,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5.h,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => GroupChatDetailPage(
                                                                                        note: e['note'],
                                                                                        groupID: _groupID,
                                                                                        paymentID: e.id,
                                                                                        userReqID: e['id'],
                                                                                        endTime: e['endTime'].toDate(),
                                                                                        amountMember: e2['amount'],
                                                                                        docID: e.id,
                                                                                        status: e2['status'],
                                                                                        amount: e['amount'],
                                                                                      ),
                                                                                      // GroupChatDetailPage(
                                                                                      //       note: e['note'],
                                                                                      //       endTime: e['endTime'].toDate(),
                                                                                      //       amountMember: e2['amount'],
                                                                                      //     )
                                                                                    ));
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                                                                                decoration: BoxDecoration(
                                                                                  color: HexColor('#EBEDEE'),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topRight: Radius.circular(10.r),
                                                                                    bottomRight: Radius.circular(10.r),
                                                                                    bottomLeft: Radius.circular(10.r),
                                                                                  ),
                                                                                ),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        width: 155.w,
                                                                                        child: Text(
                                                                                          e['note'] == '' ? 'Tidak ada catatan' : e['note'],
                                                                                          // 'Sewa Lapangan',
                                                                                          style: chatTitleGroup,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: 8.h,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 155.w,
                                                                                      child: Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: FittedBox(
                                                                                            fit: BoxFit.scaleDown,
                                                                                            child: Text(
                                                                                              convertToIdr(e2['amount']),
                                                                                              // 'Total: 20.000',
                                                                                              style: chatMoneyGroup,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 4.h,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'Status: ',
                                                                                              style: chatTitleGroup,
                                                                                            ),
                                                                                            e2['statusPayment']
                                                                                                ? Text(
                                                                                                    'Already Paid',
                                                                                                    style: chatStatusGreenGroup,
                                                                                                  )
                                                                                                : //untuk pending pake chatStatusYellowGroup
                                                                                                Text(
                                                                                                    'Pending',
                                                                                                    style: chatStatusYellowGroup,
                                                                                                  ) //untuk pending pake chatStatusYellowGroup
                                                                                          ],
                                                                                        ),
                                                                                        IconButton(
                                                                                          onPressed: () {},
                                                                                          icon: Icon(
                                                                                            Icons.arrow_forward_ios_rounded,
                                                                                            color: buttonMain,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                      .toList());
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ))
                                    .toList());
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    )
                  ],
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
      bottomSheet: Container(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplitBillDetailPage(
                        friendName: friendName,
                        friendID: friendID,
                        friendEmail: friendEmail,
                        friendPhoto: friendPhoto,
                        userName: userName!,
                        userID: userID!,
                        userEmail: userEmail!,
                        userPhoto: userPhoto!,
                        isGroup: true,
                        groupID: _groupID,
                        friendDeviceToken: const ['joni'],
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonMain),
                ),
                child: Text(
                  'Buat Request',
                  style: textButton,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
