import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marcha_branch/models/user_model.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUser(UserModel user) async {
    try {
      print('======= HAMPIR  SET USER ');
      _userReference
          .doc(user.id)
          .set({'email': user.email, 'name': user.name, 'balance': 0});
    } catch (e) {
      print('======= GAGAL MASUK  SET USER ');
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        photo: snapshot['photo'],
        balance: snapshot['balance'],
        pin: snapshot['pin'],
        deviceToken: snapshot['deviceToken'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
