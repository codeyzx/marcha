// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// class Chat {
//   List<String>? connections;
//   int? totalChats;
//   int? totalRead;
//   int? totalUnread;
//   List<Chat>? chats;
//   DateTime? lastTime;
//   Chat({
//     this.connections,
//     this.totalChats,
//     this.totalRead,
//     this.totalUnread,
//     this.chats,
//     this.lastTime,
//   });

//   Chat copyWith({
//     List<String>? connections,
//     int? totalChats,
//     int? totalRead,
//     int? totalUnread,
//     List<Chat>? chats,
//     DateTime? lastTime,
//   }) {
//     return Chat(
//       connections: connections ?? this.connections,
//       totalChats: totalChats ?? this.totalChats,
//       totalRead: totalRead ?? this.totalRead,
//       totalUnread: totalUnread ?? this.totalUnread,
//       chats: chats ?? this.chats,
//       lastTime: lastTime ?? this.lastTime,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'connections': connections,
//       'totalChats': totalChats,
//       'totalRead': totalRead,
//       'totalUnread': totalUnread,
//       'chats': chats?.map((x) => x?.toMap())?.toList(),
//       'lastTime': lastTime?.millisecondsSinceEpoch,
//     };
//   }

//   factory Chat.fromMap(Map<String, dynamic> map) {
//     return Chat(
//       connections: List<String>.from(map['connections']),
//       totalChats: map['totalChats']?.toInt(),
//       totalRead: map['totalRead']?.toInt(),
//       totalUnread: map['totalUnread']?.toInt(),
//       chats: map['chats'] != null
//           ? List<Chat>.from(map['chats']?.map((x) => Chat.fromMap(x)))
//           : null,
//       lastTime: map['lastTime'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['lastTime'])
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'Chat(connections: $connections, totalChats: $totalChats, totalRead: $totalRead, totalUnread: $totalUnread, chats: $chats, lastTime: $lastTime)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is Chat &&
//         listEquals(other.connections, connections) &&
//         other.totalChats == totalChats &&
//         other.totalRead == totalRead &&
//         other.totalUnread == totalUnread &&
//         listEquals(other.chats, chats) &&
//         other.lastTime == lastTime;
//   }

//   @override
//   int get hashCode {
//     return connections.hashCode ^
//         totalChats.hashCode ^
//         totalRead.hashCode ^
//         totalUnread.hashCode ^
//         chats.hashCode ^
//         lastTime.hashCode;
//   }
// }
import 'dart:convert';

Chats ChatsFromJson(String str) => Chats.fromJson(json.decode(str));
String ChatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  List<String>? connections;
  List<Chat>? chat;

  Chats({
    this.connections,
    this.chat,
  });

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        connections: List<String>.from(json['connections'].map((x) => x)),
        chat: List<Chat>.from(json['chat'].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'connections': List<dynamic>.from(connections!.map((e) => e)),
        'chat': List<dynamic>.from(chat!.map((e) => e.toJson())),
      };
}

class Chat {
  Chat({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json['pengirim'],
        penerima: json['penerima'],
        pesan: json['pesan'],
        time: json['time'],
        isRead: json['isRead'],
      );

  Map<String, dynamic> toJson() => {
        'pengirim': pengirim,
        'penerima': penerima,
        'pesan': pesan,
        'time': time,
        'isRead': isRead,
      };
}
