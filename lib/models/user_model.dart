import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String id;
  final String email;
  final String name;
  final String photo;
  final String deviceToken;
  final int balance;
  final int pin;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.photo,
    required this.deviceToken,
    required this.balance,
    required this.pin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        photo: json['photo'],
        balance: json['balance'],
        pin: json['pin'],
        deviceToken: json['deviceToken'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'photo': photo,
        'balance': balance,
        'pin': pin,
        'deviceToken': deviceToken,
      };
}
