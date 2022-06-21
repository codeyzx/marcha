import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcha_branch/cubit/auth_cubit.dart';
import 'package:marcha_branch/models/user_model.dart';
import 'package:marcha_branch/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marcha_branch/ui/botnavbar.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as storage;

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  File? image;
  TextEditingController name = TextEditingController();

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
        .child('profile')
        .child(DateTime.now().toIso8601String() + p.basename(image!.path));

    final results = await ref.putFile(File(image!.path));
    final imageUrl = await results.ref.getDownloadURL();

    print('Link Download : $imageUrl');
    return imageUrl;
  }

  Future updateProfile(String id) async {
    Map<String, dynamic> data = {};
    // data['name'] = name.text;
    if (image != null) {
      String url = await uploadImage();
      data['photo'] = url;
      data['name'] = name.text;
    } else {
      data['name'] = name.text;
    }

    await FirebaseFirestore.instance.collection("users").doc(id).update(data);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: titleEdit,
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return StreamBuilder<QuerySnapshot>(
                stream: users
                    .where('email', isEqualTo: state.user.email)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: (snapshot.data!).docs.map((e) {
                        name.text = e['name'];
                        return GestureDetector(
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 24.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      child: image != null
                                          ? Image(
                                              image: FileImage(image!),
                                              width: 80.w,
                                              height: 80.w,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.network(
                                              // 'https://user-images.githubusercontent.com/70552996/164889649-38092a1e-2bb7-46cf-bd37-8d916a9a6828.jpg',
                                              e['photo'],
                                              width: 80.w,
                                              height: 80.h,
                                              fit: BoxFit.fill,
                                            )),
                                  TextButton(
                                    onPressed: () async {
                                      await pickImage();
                                      print('INI IMAGE $image');
                                    },
                                    child: Text(
                                      "Ubah Foto",
                                      style: addText,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      "Nama",
                                      style: labelEdit,
                                    ),
                                    TextFormField(
                                      controller: name,
                                      onChanged: (val) {
                                        name.text = val;
                                        name.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: name.text.length));
                                      },
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor('#E5E5E5'),
                                            width: 1.w,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor('#E5E5E5'),
                                            width: 1.w,
                                          ),
                                        ),
                                      ),
                                      style: inputEdit,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),

                                    // Text(
                                    //   "Username",
                                    //   style: labelEdit,
                                    // ),
                                    // TextFormField(
                                    //   decoration: InputDecoration(
                                    //     border: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //     enabledBorder: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   style: inputEdit,
                                    // ),
                                    // SizedBox(
                                    //   height: 20.h,
                                    // ),
                                    // Text(
                                    //   "Bio",
                                    //   style: labelEdit,
                                    // ),
                                    // TextFormField(
                                    //   decoration: InputDecoration(
                                    //     border: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //     enabledBorder: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   style: inputEdit,
                                    // ),
                                    // SizedBox(
                                    //   height: 20.h,
                                    // ),
                                    // Text(
                                    //   "Bandung",
                                    //   style: labelEdit,
                                    // ),
                                    // TextFormField(
                                    //   decoration: InputDecoration(
                                    //     border: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //     enabledBorder: UnderlineInputBorder(
                                    //       borderSide: BorderSide(
                                    //         color: HexColor('#E5E5E5'),
                                    //         width: 1.w,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   style: inputEdit,
                                    // ),
                                    // SizedBox(
                                    //   height: 20.h,
                                    // ),

                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: SizedBox(
                                          width: 1.sw,
                                          height: 55.h,
                                          child: TextButton(
                                            onPressed: () async {
                                              // if (image != null) {
                                              //   await uploadImage();
                                              // }

                                              await updateProfile(
                                                  state.user.id);

                                              UserModel(
                                                id: e.id,
                                                email: e['email'],
                                                name: e['name'],
                                                photo: e['photo'],
                                                balance: e['balance'],
                                                pin: e['pin'],
                                              );

                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BotNavBar()));
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      buttonMain),
                                            ),
                                            child: Text(
                                              'Ubah Profile',
                                              style: textButton,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                });
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
