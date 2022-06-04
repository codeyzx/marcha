/// == AUTO GENERATE
// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// import 'package:marcha_branch/models/chats_model.dart';

// class UserModel {
//   final String id;
//   final String email;
//   final String name;
//   final int balance;
//   final List<Chat> chats;
//   UserModel({
//     required this.id,
//     required this.email,
//     required this.name,
//     required this.balance,
//     required this.chats,
//   });

//   UserModel copyWith({
//     String? id,
//     String? email,
//     String? name,
//     int? balance,
//     List<Chat>? chats,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       name: name ?? this.name,
//       balance: balance ?? this.balance,
//       chats: chats ?? this.chats,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//       'balance': balance,
//       'chats': chats.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       name: map['name'] ?? '',
//       balance: map['balance']?.toInt() ?? 0,
//       chats: List<Chat>.from(map['chats']?.map((x) => Chat.fromMap(x))),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserModel.fromJson(String source) =>
//       UserModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'UserModel(id: $id, email: $email, name: $name, balance: $balance, chats: $chats)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is UserModel &&
//         other.id == id &&
//         other.email == email &&
//         other.name == name &&
//         other.balance == balance &&
//         listEquals(other.chats, chats);
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         email.hashCode ^
//         name.hashCode ^
//         balance.hashCode ^
//         chats.hashCode;
//   }
// }

/// === ORIGINAL
// import 'package:equatable/equatable.dart';

// class UserModel extends Equatable {
//   final String id;
//   final String email;
//   final String name;
//   final int balance;

//   const UserModel(
//       {required this.id,
//       required this.email,
//       required this.name,
//       required this.balance});

//   factory UserModel.fromMap(data) => UserModel(
//         id: data['id'],
//         email: data['email'],
//         name: data['name'],
//         balance: data['balance'],
//       );

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//       'balance': balance,
//     };
//   }

//   UserModel copyWith({String? id, String? email, String? name, int? balance}) =>
//       UserModel(
//           id: id ?? this.id,
//           email: email ?? this.email,
//           name: name ?? this.name,
//           balance: balance ?? this.balance);

//   @override
//   List<Object?> get props => [id, email, name, balance];
// }

/// === KULDII

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String id;
  final String email;
  final String name;
  final String photo;
  final int balance;
  final int pin;
  // final List? chats;

  const UserModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.photo,
      required this.balance,
      required this.pin,
      // required this.chats
      });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photo: json['photo'],
      balance: json['balance'],
      pin: json['pin'],
      // chats:
          // List<ChatUser>.from(json['chats'].map((x) => ChatUser.fromJson(x)))
          );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'photo': photo,
        'balance': balance,
        'pin': pin,
        // 'chats': List<dynamic>.from(chats!.map((e) => e.toJson())),
      };
}

class ChatUser {
  ChatUser({
    required this.connection,
    required this.chatId,
    required this.lastTime,
    required this.totalUnread,
  });

  final String connection;
  final String chatId;
  final String lastTime;
  final int totalUnread;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
      connection: json['connection'],
      chatId: json['chatId'],
      lastTime: json['lastTime'],
      totalUnread: json['totalUnread'],
      
      );

  Map<String, dynamic> toJson() => {
        'connection': connection,
        'chat_id': chatId,
        'lastTime': lastTime,
        'totalUnread': totalUnread,
      };
}
