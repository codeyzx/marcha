import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marcha_branch/models/user_model.dart';
import 'package:marcha_branch/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final GoogleSignInAccount? _currentUser;

  final User? currUser = FirebaseAuth.instance.currentUser;
  late final UserCredential? userCredential;

  Future updateDeviceToken(String userDoc, String token) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    FirebaseFirestore.instance
        .collection("users")
        .doc(userDoc)
        .collection('friends')
        .where('deviceToken', isNotEqualTo: token)
        .get()
        .then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        try {
          batch.update(document.reference, {"deviceToken": token});
        } on FormatException catch (error) {
          print("The document ${error.source} could not be parsed.");
          continue;
        }
      }
      return batch.commit();
    });
  }

  Future<UserModel> googleLogin() async {
    try {
      CollectionReference userReference =
          FirebaseFirestore.instance.collection('users');

      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();
      print('APAKAH SUDAH LOGIN? ($isSignIn)');

      print('SUDAH BERHASIL LOGIN DENGAN AKUN: ');
      print(_currentUser);

      final googleAuth = await _currentUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => userCredential = value);

      String? token = await FirebaseMessaging.instance.getToken();

      final checkUser =
          await userReference.doc(userCredential!.user!.uid).get();

      Map<String, dynamic>? data = checkUser.data() as Map<String, dynamic>?;

      if (checkUser.data() == null) {
        print('USER DATA IS TRUE, AKAN SET DOCUMENT:');
        userReference.doc(userCredential!.user!.uid).set({
          'id': userCredential!.user!.uid,
          'balance': 0,
          'name': _currentUser!.displayName,
          'email': _currentUser!.email,
          'photo': _currentUser!.photoUrl,
          'status': '',
          'creationTime':
              userCredential!.user!.metadata.creationTime!.toIso8601String(),
          'lastSignInTime':
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
          'updatedTime': DateTime.now().toIso8601String(),
          'deviceToken': token,
          'pin': 0,
        });
        userReference.doc(userCredential!.user!.uid).collection('chats');
      } else {
        if (data!['deviceToken'] != token || data.length < 11) {
          updateDeviceToken(userCredential!.user!.uid, token!);

          userReference.doc(userCredential!.user!.uid).update({
            'deviceToken': token,
          });
        }
      }

      UserModel user =
          await UserService().getUserById(userCredential!.user!.uid);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> uidLogin(Response dataResponseToken) async {
    try {
      CollectionReference userReference =
          FirebaseFirestore.instance.collection('users');
      SharedPreferences pref = await SharedPreferences.getInstance();

      String? token = await FirebaseMessaging.instance.getToken();

      final checkUser = await userReference
          .doc(dataResponseToken.data['data']['user_id'].toString())
          .get();

      Map<String, dynamic>? userData =
          checkUser.data() as Map<String, dynamic>?;

      if (checkUser.data() == null) {
        await userReference
            .doc(dataResponseToken.data['data']['user_id'].toString())
            .set({
          'id': dataResponseToken.data['data']['user_id'].toString(),
          'name': dataResponseToken.data['data']['fullname'],
          'email': dataResponseToken.data['data']['email'],
          'status': dataResponseToken.data['data']['verification_statuses'],
          'photo':
              'https://lh3.googleusercontent.com/a-/AFdZucpPynrcN_TvOgSOJDHqWeTCI8w0lROK70AVYorD=s96-c',
          'balance': 0,
          'pin': 0,
          'deviceToken': token
        });
      } else {
        if (userData!['deviceToken'] != token || userData.length < 11) {
          updateDeviceToken(
              dataResponseToken.data['data']['user_id'].toString(), token!);

          userReference
              .doc(dataResponseToken.data['data']['user_id'].toString())
              .update({
            'deviceToken': token,
            'status': dataResponseToken.data['data']['verification_statuses'],
          });
        }
      }

      await pref.setString(
          'uid', (dataResponseToken.data['data']['user_id'].toString()));

      UserModel user = await UserService()
          .getUserById(dataResponseToken.data['data']['user_id'].toString());

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('uid');
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          photo: '',
          balance: 0,
          pin: 0,
          deviceToken: '');

      await UserService().setUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
