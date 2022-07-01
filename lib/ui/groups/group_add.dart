import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:marcha_branch/ui/groups/group_page.dart';

class GroupAdd extends StatefulWidget {
  const GroupAdd({Key? key}) : super(key: key);

  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  final List<String> _friendName = [];
  final List<String> _friendID = [];
  final List<String> _friendEmail = [];
  final TextEditingController _group = TextEditingController();

  @override
  void dispose() {
    _group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');
    final groupsColl = groups.doc();
    final groupsID = groupsColl.id;
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 12.w, top: 20.h, right: 20.w, bottom: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Group",
                    style: subTitleText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextField(
                    controller: _group,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Nama Group Anda',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor('#ECDAFF'),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor('#ECDAFF'),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    style: inputNote,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Tambahkan Teman",
                    style: subTitleText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is AuthSuccess) {
                      return Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: users.snapshots(),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: (snapshot.data!)
                                      .docs
                                      .map(
                                        (data) => ListTile(
                                          title: Text(data['name']),
                                          trailing: Checkbox(
                                            value: _friendName
                                                .contains(data['name']),
                                            onChanged: (val) {
                                              _onSelected(val!, data['name'],
                                                  data.id, data['email']);
                                            },
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
                  }),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 320.w,
                      height: 55.h,
                      child: TextButton(
                        onPressed: () async {
                          print(_friendID.length);

                          await groupsColl.set({
                            'name': _group.text,
                            'membersEmail': _friendEmail,
                          });

                          print('GROUPSID: $groupsID');

                          for (var i = 0; i < _friendID.length; i++) {
                            await groups
                                .doc(groupsID)
                                .collection('members')
                                .doc(_friendID[i])
                                .set({
                              'id': _friendID[i],
                              'name': _friendName[i],
                              'email': _friendEmail[i],
                            });

                            
                          }

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupPage(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelected(
    bool selected,
    String name,
    String id,
    String email,
  ) {
    if (selected == true) {
      setState(() {
        _friendName.add(name);
        _friendID.add(id);
        _friendEmail.add(email);
      });
    } else {
      setState(() {
        _friendName.remove(name);
        _friendID.remove(id);
        _friendEmail.remove(email);
      });
    }
  }
}
