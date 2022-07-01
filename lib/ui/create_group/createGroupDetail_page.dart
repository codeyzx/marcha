import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcha_branch/shared/theme.dart';

import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as storage;

class CreateGroupDetailPage extends StatefulWidget {
  final List<String> friendName;
  final List<String> friendID;
  final List<String> friendEmail;
  final List<String> friendPhoto;
  final String userName;
  final String userID;
  final String userEmail;
  final String userPhoto;
  const CreateGroupDetailPage({
    Key? key,
    required this.friendName,
    required this.friendID,
    required this.friendEmail,
    required this.friendPhoto,
    required this.userName,
    required this.userID,
    required this.userEmail,
    required this.userPhoto,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _CreateGroupDetailPageState createState() => _CreateGroupDetailPageState(
        friendName,
        friendID,
        friendEmail,
        friendPhoto,
        userName,
        userID,
        userEmail,
        userPhoto,
      );
}

class _CreateGroupDetailPageState extends State<CreateGroupDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _friendName;
  final List<String> _friendID;
  final List<String> _friendEmail;
  final List<String> _friendPhoto;
  final String _userName;
  final String _userID;
  final String _userEmail;
  final String _userPhoto;

  final TextEditingController _groupName = TextEditingController();

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          this.image = File(image.path);
        });
      }

      // final imageTemporary = File(image.path);
      // setState(() {
      //   this.image = imageTemporary;
      // });
    } on PlatformException catch (e) {
      print('Failed to Pick Image: $e');
    }
  }

  Future<String> uploadImage() async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('groups')
        .child(DateTime.now().toIso8601String() + p.basename(image!.path));

    final results = await ref.putFile(File(image!.path));
    final imageUrl = await results.ref.getDownloadURL();

    print('Link Download : $imageUrl');
    return imageUrl;
  }

  Future update(String id) async {
    Map<String, dynamic> data = {};
    // data['name'] = name.text;
    if (image != null) {
      String url = await uploadImage();
      data['photo'] = url;
    } else {
      data['photo'] =
          'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg';
    }

    await FirebaseFirestore.instance.collection("users").doc(id).update(data);
  }

  _CreateGroupDetailPageState(
    this._friendName,
    this._friendID,
    this._friendEmail,
    this._friendPhoto,
    this._userName,
    this._userID,
    this._userEmail,
    this._userPhoto,
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');
    final groupsColl = groups.doc();
    final groupsID = groupsColl.id;
    CollectionReference payment =
        FirebaseFirestore.instance.collection('payment');
    final paymentColl = payment.doc();
    final paymentID = paymentColl.id;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
            "Set Group",
            style: appbarTxt,
          ),
          centerTitle: true,
        ),
        body: ListView(
          
        padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 85.w,
                        height: 85.h,
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: image != null
                                    ? Image(
                                        image: FileImage(image!),
                                        width: 80.w,
                                        height: 80.w,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        'assets/images/logo-marcha-img.png',
                                        // "https://static.republika.co.id/uploads/images/inpicture_slide/delegasi-indonesoa-di-sidang-umum-pbb-tahun-1947-terlihat-_181010145459-862.jpg",
                                        width: 80.w,
                                        height: 80.w,
                                        fit: BoxFit.cover,
                                      )),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: HexColor("#ECDAFF"),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Image.asset(
                                        'assets/images/icon_camera.png'),
                                    onPressed: () async {
                                      await pickImage();
                                      print('INI IMAGE $image');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 222.w,
                        height: 35.h,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _groupName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Name of group must be filled'
                                  : null;
                            },
                            decoration: InputDecoration(
                              hintText: "Group Name",
                              hintStyle: hintGroupName,
                            ),
                            style: inputGroupName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Member ${_friendName.length}",
                    style: subTitleText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 300.w,
                          height: 100.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _friendName.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: 70.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: Image.network(
                                            _friendPhoto[index],
                                            width: 60.w,
                                            height: 60.h,
                                            fit: BoxFit.cover,
                                          )),
                                      Text(
                                        _friendName[index],
                                        style: nameTxt,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _friendEmail.add(_userEmail);
                      _friendName.add(_userName);
                      _friendPhoto.add(_userPhoto);
                      _friendID.add(_userID);

                      print(_friendEmail);

                      if (image != null) {
                        String url = await uploadImage();
                        await groupsColl.set({
                          'name': _groupName.text,
                          'photo': url,
                          'adminID': _userID,
                          'adminName': _userName,
                          'adminEmail': _userEmail,
                          'adminPhoto': _userPhoto,
                          'membersEmail': _friendEmail,
                          'membersName': _friendName,
                        });
                      } else {
                        await groupsColl.set({
                          'name': _groupName.text,
                          'photo':
                              'https://lh3.googleusercontent.com/a-/AOh14GhHMyAoaXji1i1anunti7-09ucqVVBgNg1DmtiE=s96-c',
                          'adminID': _userID,
                          'adminName': _userName,
                          'adminEmail': _userEmail,
                          'adminPhoto': _userPhoto,
                          'membersEmail': _friendEmail,
                          'membersName': _friendName,
                        });
                      }

                      for (var i = 0; i < _friendID.length; i++) {
                        await groups
                            .doc(groupsID)
                            .collection('member')
                            .doc(_friendID[i])
                            .set({
                          'id': _friendID[i],
                          'name': _friendName[i],
                          'email': _friendEmail[i],
                          'photo': _friendPhoto[i],
                        });
                      }

                      /* PAYMENT 
                    await groupsColl.collection('payment').doc(paymentID).set({
                      'userReqID': _userID,
                      'userReqName': _userName,
                      'userReqEmail': _userEmail,
                      'membersEmail': _friendEmail,
                    });

                    print('GROUPSID: $groupsID');

                    for (var i = 0; i < _friendID.length; i++) {
                      await groups
                          .doc(groupsID)
                          .collection('payment')
                          .doc(paymentID)
                          .collection('members')
                          .doc(_friendID[i])
                          .set({
                        'id': _friendID[i],
                        'name': _friendName[i],
                        'email': _friendEmail[i],
                      });
                    }
                     */

                      // for (var i = 0; i < _friendID.length; i++) {
                      //   await groups
                      //       .doc(groupsID)
                      //       .collection('payment')
                      //       .doc(_friendID[i])
                      //       .set({
                      //     'id': _friendID[i],
                      //     'name': _friendName[i],
                      //     'email': _friendEmail[i],
                      //   });
                      // }

                      Navigator.pushReplacementNamed(context, '/nav-bar');

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => BotNavBar(),
                      //     ));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(buttonMain),
                  ),
                  child: Text(
                    'Buat',
                    style: textButton,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
