import 'package:marcha_branch/models/topup.dart';

class TopUpRespone {
  late List<TopUp> results;

  TopUpRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      results = <TopUp>[];
      json['data'].forEach((v) {
        results.add(TopUp.fromJson(v));
      });
    }
  }
}
