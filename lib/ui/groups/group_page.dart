import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/create_group/createGroup_page.dart';
import 'package:marcha_branch/ui/friends/search_page.dart';
import 'package:marcha_branch/ui/groups/group_chat_page.dart';
import 'package:marcha_branch/ui/qr/qr_scan.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Group",
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
            Padding(
              padding: EdgeInsets.only(
                  left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        )),
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
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Group",
                        style: subTitleText,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateGroupPage(
                                isAdd: false,
                                groupID: '',
                                members: const [], membersName: const [], membersEmail: const [],
                              ),
                            )),
                        child: Text(
                          "Create New (+)",
                          style: addText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  // Before Updated
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AuthSuccess) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: groups
                              .where('membersEmail',
                                  arrayContains: state.user.email)
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isNotEmpty) {
                                // TAMBAHIN PAGE KOSONG DISINI
                                return Column(
                                    children: snapshot.data!.docs
                                        .map(
                                          (e2) => Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GroupChatPage(
                                                                groupID: e2.id,
                                                                email: state
                                                                    .user
                                                                    .email),
                                                      ));
                                                },
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.r),
                                                        child: e2['photo'] == ''
                                                            ? Image.asset(
                                                                'assets/images/logo-marcha-img.png', // "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg",
                                                                width: 60.w,
                                                                height: 60.h,
                                                              )
                                                            : Image.network(
                                                                e2['photo'],
                                                                // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                                                // "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg",
                                                                width: 60.w,
                                                                height: 60.h,
                                                              )),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                            width: 180.w,
                                                            child: Text(
                                                              e2['name'],
                                                              style: titleName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            )),
                                                        SizedBox(
                                                            width: 180.w,
                                                            child: Text(
                                                              "You owe: 20.000",
                                                              style: username,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            )),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            // width: 150.w,
                                                            child: Text(
                                                          "20:05",
                                                          style: titleName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        )),
                                                        Container(
                                                            // width: 150.w,
                                                            child: Text(
                                                          "1",
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
                                        .toList());
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 58.h,
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
                                      'Tidak ada Group',
                                      style: titleElse,
                                    ),
                                    Text(
                                      'Buat atau masuk grup terlebih dahulu',
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
                                                          CreateGroupPage(
                                                            isAdd: false,
                                                            groupID: '',
                                                            members: const [], membersName: const [], membersEmail: const [],
                                                          )));
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      buttonMain),
                                            ),
                                            child: Text(
                                              'Create',
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
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),

                  // // Before Updated
                  // BlocBuilder<AuthCubit, AuthState>(
                  //   builder: (context, state) {
                  //     if (state is AuthLoading) {
                  //       return Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } else if (state is AuthSuccess) {
                  //       return StreamBuilder<QuerySnapshot>(
                  //         stream: groups
                  //             .where('membersEmail',
                  //                 arrayContains: state.user.email)
                  //             .snapshots(),
                  //         builder: (_, snapshot) {
                  //           if (snapshot.hasData) {
                  //             if (snapshot.data!.docs.isNotEmpty) {
                  //               // TAMBAHIN PAGE KOSONG DISINI
                  //               return Column(
                  //                   children: snapshot.data!.docs
                  //                       .map(
                  //                         (e2) => StreamBuilder<QuerySnapshot>(
                  //                           stream: FirebaseFirestore.instance
                  //                               .collection('groups')
                  //                               .doc(e2.id)
                  //                               .collection('members')
                  //                               .where('id',
                  //                                   isEqualTo: state.user.id)
                  //                               // .where('status',
                  //                               //     isEqualTo: false)
                  //                               .snapshots(),
                  //                           builder: (_, snapshot) {
                  //                             if (snapshot.hasData) {
                  //                               return Column(
                  //                                 children: snapshot.data!.docs
                  //                                     .map(
                  //                                       (e3) => Column(
                  //                                         children: [
                  //                                           InkWell(
                  //                                             onTap: () {
                  //                                               Navigator.push(
                  //                                                   context,
                  //                                                   MaterialPageRoute(
                  //                                                     builder:
                  //                                                         (context) =>
                  //                                                             GroupChatPage(),
                  //                                                   ));
                  //                                             },
                  //                                             child: Row(
                  //                                               children: [
                  //                                                 ClipRRect(
                  //                                                     borderRadius:
                  //                                                         BorderRadius.circular(15
                  //                                                             .r),
                  //                                                     child: Image
                  //                                                         .network(
                  //                                                       'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                  //                                                       // "https://cerahnews.com/wp-content/uploads/2018/01/16176889_112685309244626_578204711_n-e1516135518784.jpg",
                  //                                                       width:
                  //                                                           60.w,
                  //                                                       height:
                  //                                                           60.h,
                  //                                                     )),
                  //                                                 SizedBox(
                  //                                                   width: 15.w,
                  //                                                 ),
                  //                                                 Column(
                  //                                                   mainAxisAlignment:
                  //                                                       MainAxisAlignment
                  //                                                           .center,
                  //                                                   crossAxisAlignment:
                  //                                                       CrossAxisAlignment
                  //                                                           .start,
                  //                                                   children: [
                  //                                                     SizedBox(
                  //                                                         width: 180
                  //                                                             .w,
                  //                                                         child:
                  //                                                             Text(
                  //                                                           e2['name'],
                  //                                                           style:
                  //                                                               titleName,
                  //                                                           overflow:
                  //                                                               TextOverflow.ellipsis,
                  //                                                           maxLines:
                  //                                                               1,
                  //                                                         )),
                  //                                                     SizedBox(
                  //                                                         width: 180
                  //                                                             .w,
                  //                                                         child:
                  //                                                             Text(
                  //                                                           "You owe: 20.000",
                  //                                                           style:
                  //                                                               username,
                  //                                                           overflow:
                  //                                                               TextOverflow.ellipsis,
                  //                                                           maxLines:
                  //                                                               1,
                  //                                                         )),
                  //                                                   ],
                  //                                                 ),
                  //                                                 Column(
                  //                                                   mainAxisAlignment:
                  //                                                       MainAxisAlignment
                  //                                                           .center,
                  //                                                   crossAxisAlignment:
                  //                                                       CrossAxisAlignment
                  //                                                           .start,
                  //                                                   children: [
                  //                                                     Container(
                  //                                                         // width: 150.w,
                  //                                                         child:
                  //                                                             Text(
                  //                                                       "20:05",
                  //                                                       style:
                  //                                                           titleName,
                  //                                                       overflow:
                  //                                                           TextOverflow.ellipsis,
                  //                                                       maxLines:
                  //                                                           1,
                  //                                                     )),
                  //                                                     Container(
                  //                                                         // width: 150.w,
                  //                                                         child:
                  //                                                             Text(
                  //                                                       "1",
                  //                                                       style:
                  //                                                           username,
                  //                                                       overflow:
                  //                                                           TextOverflow.ellipsis,
                  //                                                       maxLines:
                  //                                                           1,
                  //                                                     )),
                  //                                                   ],
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                           SizedBox(
                  //                                             height: 18.h,
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     )
                  //                                     .toList(),
                  //                               );
                  //                             } else {
                  //                               return Center(
                  //                                 child:
                  //                                     CircularProgressIndicator(),
                  //                               );
                  //                             }
                  //                           },
                  //                         ),
                  //                       )
                  //                       .toList());
                  //             } else {
                  //               return Column(
                  //                 children: [
                  //                   SizedBox(
                  //                     height: 58.h,
                  //                   ),
                  //                   Image.asset(
                  //                     'assets/images/group-else-img.png',
                  //                     width: 240.w,
                  //                     height: 108.43.h,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 27.h,
                  //                   ),
                  //                   Text(
                  //                     'Tidak ada Group',
                  //                     style: titleElse,
                  //                   ),
                  //                   Text(
                  //                     'Buat atau masuk grup terlebih dahulu',
                  //                     style: subTitleElse,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 18.h,
                  //                   ),
                  //                   Align(
                  //                     alignment: Alignment.center,
                  //                     child: ClipRRect(
                  //                       borderRadius:
                  //                           BorderRadius.circular(6.r),
                  //                       child: SizedBox(
                  //                         width: 180.w,
                  //                         height: 46.h,
                  //                         child: TextButton(
                  //                           onPressed: () {
                  //                             Navigator.push(
                  //                                 context,
                  //                                 MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         CreateGroupPage()));
                  //                           },
                  //                           style: ButtonStyle(
                  //                             backgroundColor:
                  //                                 MaterialStateProperty.all(
                  //                                     buttonMain),
                  //                           ),
                  //                           child: Text(
                  //                             'Create',
                  //                             style: textButton,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               );
                  //             }
                  //           } else {
                  //             return Center(
                  //               child: CircularProgressIndicator(),
                  //             );
                  //           }
                  //         },
                  //       );
                  //     } else {
                  //       return SizedBox();
                  //     }
                  //   },
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
