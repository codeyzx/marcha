import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marcha_branch/models/user_model.dart';
import 'package:marcha_branch/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;

  User? currUser = FirebaseAuth.instance.currentUser;
  UserCredential? userCredential;

  // Future<UserModel> googleLogin() async {
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
  //           // 'chats': []
  //         });
  //         _userReference.doc(userCredential!.user!.uid).collection('chats');
  //       } else {
  //         print('USER DATA IS FALSE:');
  //         _userReference.doc(userCredential!.user!.uid).update({
  //           'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
  //               .toIso8601String(),
  //         });
  //       }

  //       final listChats = await _userReference
  //           .doc(userCredential!.user!.uid)
  //           .collection('chats')
  //           .get();

  //       if (listChats.docs.isNotEmpty) {
  //         List<ChatUser> dataListChats = List<ChatUser>.empty();
  //         listChats.docs.forEach((element) {
  //           var dataDocChat = element.data();
  //           var dataDocChatId = element.id;
  //           dataListChats.add(ChatUser(
  //               connection: dataDocChat['connection'],
  //               chatId: dataDocChatId,
  //               lastTime: dataDocChat['lastTime'],
  //               totalUnread: dataDocChat['totalUnread']));
  //         });
  //       }

  //       UserModel user =
  //           await UserService().getUserById(userCredential!.user!.uid);

  //       return user;
  //     } else {
  //       throw ('TIDAK BERHASIL LOGIN');
  //       // throw('TIDAK BERHASIL LOGIN');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

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
          // Only if DocumentID has only numbers
          batch.update(document.reference, {"deviceToken": token});

          // if (cart.contains(document.id)) {
          //   batch.update(document.reference, {"deviceToken": token});
          // }
        } on FormatException catch (error) {
          // If a document ID is unparsable. Example "lRt931gu83iukSSLwyei" is unparsable.
          print("The document ${error.source} could not be parsed.");
          continue;
        }
      }
      return batch.commit();
    });
  }

  Future<UserModel> googleLogin() async {
    try {
      print('masuk google login');
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();
      print('APAKAH SUDAH LOGIN? ($isSignIn)');

      // print('SUDAH BERHASIL LOGIN DENGAN AKUN: ');
      // print(_currentUser);

      final googleAuth = await _currentUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => userCredential = value);

      String? token = await FirebaseMessaging.instance.getToken();

      // print('USER CREDENTIAL:');
      // print(userCredential);

      CollectionReference _userReference =
          FirebaseFirestore.instance.collection('users');

      // print('NGEPRINT UID: ' + userCredential!.user!.uid);
      final checkUser =
          await _userReference.doc(userCredential!.user!.uid).get();

      Map<String, dynamic>? data = checkUser.data()! as Map<String, dynamic>?;

      // print('CHECK USER DATA UTK NGESET:');
      // print(data!['deviceToken']);
      // print(checkUser.data());
      // print('user data: ${checkUser.data()}');
      if (checkUser.data() == null) {
        _userReference.doc(userCredential!.user!.uid).set({
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
      } else {
        if (data!['deviceToken'] != token || data.length < 11) {
          updateDeviceToken(userCredential!.user!.uid, token!);

          _userReference.doc(userCredential!.user!.uid).update({
            'deviceToken': token,
          });
        }
      }
      // print('USER DATA IS TRUE, AKAN SET DOCUMENT:');
      // _userReference.doc(userCredential!.user!.uid).set({
      //   'id': userCredential!.user!.uid,
      //   'balance': 0,
      //   'name': _currentUser!.displayName,
      //   'email': _currentUser!.email,
      //   'photo': _currentUser!.photoUrl,
      //   'status': '',
      //   'creationTime':
      //       userCredential!.user!.metadata.creationTime!.toIso8601String(),
      //   'lastSignInTime':
      //       userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      //   'updatedTime': DateTime.now().toIso8601String(),
      //   'deviceToken': token,
      //   'pin': 0,
      //   // 'chats': []
      // });
      // _userReference.doc(userCredential!.user!.uid).collection('chats');

      // else {
      //   // print('USER DATA IS FALSE:');
      //   _userReference.doc(userCredential!.user!.uid).update({
      //     'lastSignInTime':
      //         userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      //   });
      // }

      // final listChats = await _userReference
      //     .doc(userCredential!.user!.uid)
      //     .collection('chats')
      //     .get();

      // if (listChats.docs.isNotEmpty) {
      //   List<ChatUser> dataListChats = List<ChatUser>.empty();
      //   for (var element in listChats.docs) {
      //     var dataDocChat = element.data();
      //     var dataDocChatId = element.id;
      //     dataListChats.add(ChatUser(
      //         connection: dataDocChat['connection'],
      //         chatId: dataDocChatId,
      //         lastTime: dataDocChat['lastTime'],
      //         totalUnread: dataDocChat['totalUnread']));
      //   }
      // }

      UserModel user =
          await UserService().getUserById(userCredential!.user!.uid);
      // UserModel user = await UserService().getUserById(_currentUser!.id);

      // print('CREDENTIAL: N$userCredential');
      // print('CURRENT USER: N $_currentUser');
      // print('USER: \n ${user.pin}');

      return user;
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
      print('======= MASUK AUTH SERVICES SIGNUP ');
      print('======= MASUK USERCREDENTIAL ');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print('======= MASUK USERMODEL ');
      UserModel user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          photo: '',
          balance: 0,
          pin: 1234,
          deviceToken: ''
          // chats: []
          );

      print('======= HAMPIR MASUK SET USER ');
      await UserService().setUser(user);
      print('======= MASUK RETURN USER ');
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(String name, String email) async {
    final User user = _auth.currentUser!;
    final userId = user.uid;
    try {
      await UserService().getUserById(userId);
      CollectionReference docRef = firestore.collection('users');
      await docRef.doc(userId).set({'email': email, 'name': name});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    String chatID;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final docChats = await users.doc(currUser!.uid).collection('chats').get();

    if (docChats.docs.isNotEmpty) {
      print('USER PUNYA DOC CHAT: \n ${docChats.docs.length}');
      // user have chat with anyone
      final checkConnection = await users
          .doc(currUser!.uid)
          .collection('chats')
          .where('connection', isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        print('USER PERNAH CHATAN DENGAN TEMAN: \n ${docChats.docs.length}');
        flagNewConnection = false;
        chatID = checkConnection.docs[0].id; //chatID
        print('CHAT ID: $chatID');
      } else {
        flagNewConnection = true;
      }
    } else {
      print(
          'USER TIDAK PERNAH CHATAN DENGAN TEMAN: \n ${docChats.docs.length}');
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      final chatsDocs = await chats.where('connections', whereIn: [
        [
          currUser!.email,
          friendEmail,
        ],
        [
          friendEmail,
          currUser!.email,
        ]
      ]).get();

      if (chatsDocs.docs.isNotEmpty) {
        print(
            'FLAG-USER PERNAH CHATAN DENGAN TEMAN: \n ${chatsDocs.docs.length}');
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        print('CHAT DOCS ID : $chatDataId');

        await users.doc(currUser!.uid).collection('chats').doc(chatDataId).set({
          'connection': friendEmail,
          'lastTime': chatsData['lastTime'],
          'total_unread': 0,
        });

        final listChats =
            await users.doc(currUser!.uid).collection('chats').get();

        // if (listChats.docs.isNotEmpty) {
        //   List<ChatUser> dataListChats = [];
        //   for (var element in listChats.docs) {
        //     var dataDocChat = element.data();
        //     var dataDocChatId = element.id;
        //     dataListChats.add(ChatUser(
        //       connection: dataDocChat['connection'],
        //       chatId: dataDocChatId,
        //       // lastTime: dataDocChat['lastTime'],
        //       lastTime: date,
        //       totalUnread: 0,
        //       // totalUnread: dataDocChat['totalUnread'],
        //     ));
        //   }
        // }

      } else {
        print(
            'FLAG-USER TIDAK PERNAH CHATAN DENGAN TEMAN: \n ${chatsDocs.docs.length}');
        final newChatDoc = await chats.add({
          'connections': [
            currUser!.email,
            friendEmail,
          ],
        });

        chats.doc(newChatDoc.id).collection('chats');

        await users
            .doc(currUser!.uid)
            .collection('chats')
            .doc(newChatDoc.id)
            .set({
          'connection': friendEmail,
          'lastTime': date,
          'total_unread': 0,
        });

        final listChats =
            await users.doc(currUser!.uid).collection('chats').get();

        // if (listChats.docs.isNotEmpty) {
        //   List<ChatUser> dataListChats = [];
        //   for (var element in listChats.docs) {
        //     var dataDocChat = element.data();
        //     var dataDocChatId = element.id;
        //     dataListChats.add(ChatUser(
        //         connection: dataDocChat['connection'],
        //         chatId: dataDocChatId,
        //         lastTime: dataDocChat['lastTime'],
        //         totalUnread: 0));
        //   }
        // }

      }
    }
  }
}
