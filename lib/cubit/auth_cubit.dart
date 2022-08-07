import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marcha_branch/models/user_model.dart';
import 'package:marcha_branch/services/auth_service.dart';
import 'package:marcha_branch/services/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserCredential? userCredential;

  // Future<void> googleLogin() async {
  //   try {
  //     await _googleSignIn.signOut();
  //     await _googleSignIn.signIn().then((value) => _currentUser = value);

  //     final isSignIn = await _googleSignIn.isSignedIn();

  //     if (isSignIn) {
  //       print('SUDAH BERHASIL LOGIN DENGAN AKUN: ');
  //       print(_currentUser);

  //       final googleAuth = await _currentUser!.authentication;

  //       final credential = GoogleAuthProvider.credential(
  //         idToken: googleAuth.idToken,
  //         accessToken: googleAuth.accessToken,
  //       );

  //       await FirebaseAuth.instance
  //           .signInWithCredential(credential)
  //           .then((value) => userCredential = value);

  //       print('USER CREDENTIAL:');
  //       print(userCredential);

  //       CollectionReference _userReference =
  //           FirebaseFirestore.instance.collection('users');

  //       print('NGEPRINT UID: ' + userCredential!.user!.uid);
  //       final checkUser =
  //           await _userReference.doc(userCredential!.user!.uid).get();

  //       print('CHECK USER DATA UTK NGESET:');
  //       print(checkUser.data());
  //       if (checkUser.data() == null) {
  //         print('USER DATA IS TRUE, AKAN SET DOCUMENT:');
  //         _userReference.doc(userCredential!.user!.uid).set({
  //           'balance': 0,
  //           'name': _currentUser!.displayName,
  //           'email': _currentUser!.email,
  //           'photo': _currentUser!.photoUrl,
  //           'status': '',
  //           'creationTime':
  //               userCredential!.user!.metadata.creationTime!.toIso8601String(),
  //           'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
  //               .toIso8601String(),
  //           'updatedTime': DateTime.now().toIso8601String(),
  //         });
  //       } else {
  //         print('USER DATA IS FALSE:');
  //         _userReference.doc(userCredential!.user!.uid).update({
  //           'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
  //               .toIso8601String(),
  //         });
  //       }
  //     } else {
  //       print('TIDAK BERHASIL LOGIN');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void googleLogin() async {
  //   try {
  //     emit(AuthLoading());
  //     UserModel user = await AuthService().googleLogin();
  //     emit(AuthSuccess(user));
  //   } catch (e) {
  //     emit(AuthFailed(e.toString()));
  //   }
  // }

  // Future<bool> autoLogin() async {
  //   try {
  //     emit(AuthLoading());

  //     debugPrint('MASUK AUTO LOGIN');

  //     final isSignIn = await _googleSignIn.isSignedIn();

  //     User? user = FirebaseAuth.instance.currentUser;

  //     UserModel users = await UserService().getUserById(user!.uid);

  //     emit(AuthSuccess(users));

  //     if (isSignIn) {
  //       return true;
  //     } else {
  //       // print(isSignIn);
  //       return false;
  //     }
  //   } catch (e) {
  //     emit(AuthFailed(e.toString()));
  //     return false;
  //   }

  //   // try {
  //   //   print('MASUK AUTO LOGIN');
  //   //   final isSignIn = await _googleSignIn.isSignedIn();
  //   //   User? user = FirebaseAuth.instance.currentUser;
  //   //   AuthCubit().getCurrentUser(user!.uid);

  //   //   // if (isSignIn) {
  //   //   //   // print(isSignIn);
  //   //   //   // print('MASUK IS SIGN');
  //   //   //   // print('================UID : ');
  //   //   //   // print(user.uid);
  //   //   //   // print('================LAST SIGN IN : ');
  //   //   //   // print(
  //   //   //   //   user.metadata.lastSignInTime!.toIso8601String(),
  //   //   //   // );
  //   //   //   // await _userReference.doc(user.uid).update({
  //   //   //   //   'lastSignInTime':
  //   //   //   //       // userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
  //   //   //   //       user.metadata.lastSignInTime!.toIso8601String(),
  //   //   //   // });
  //   //   //   // final listChats =
  //   //   //   //     await _userReference.doc(user.uid).collection('chats').get();
  //   //   //   // if (listChats.docs.isNotEmpty) {
  //   //   //   //   List<ChatUser> dataListChats = [];
  //   //   //   //   for (var element in listChats.docs) {
  //   //   //   //     print(element.data());
  //   //   //   //     var dataDocChat = element.data();
  //   //   //   //     var dataDocChatId = element.id;
  //   //   //   //     dataListChats.add(ChatUser(
  //   //   //   //         connection: dataDocChat['connection'],
  //   //   //   //         chatId: dataDocChatId,
  //   //   //   //         lastTime: dataDocChat['lastTime'],
  //   //   //   //         totalUnread: dataDocChat['totalUnread']));
  //   //   //   //   }
  //   //   //   // }
  //   //   //   return true;
  //   //   // } else {
  //   //   //   // print(isSignIn);
  //   //   //   return false;
  //   //   // }
  //   // } catch (e) {
  //   //   // print(e);
  //   //   return false;
  //   // }
  // }

  void signIn({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      UserModel user =
          await AuthService().signIn(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future googleLogin() async {
    try {
      emit(AuthLoading());
      UserModel user = await AuthService().googleLogin();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future uidLogin(Response dataResponseToken) async {
    try {
      emit(AuthLoading());
      UserModel user = await AuthService().uidLogin(dataResponseToken);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      print('======= MASUK TRY AUTH CUBIT ');
      emit(AuthLoading());
      UserModel user = await AuthService()
          .signUp(email: email, password: password, name: name);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void signOut() async {
    try {
      emit(AuthLoading());
      await AuthService().signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void getCurrentUser(String id) async {
    try {
      UserModel user = await UserService().getUserById(id);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
