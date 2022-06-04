import 'package:marcha_branch/api/api_base_helper.dart';
import 'package:marcha_branch/cubit/topup_respone.dart';
import 'package:marcha_branch/models/topup.dart';

class TopUpRepository {
  ApiBaseHelper api = ApiBaseHelper();

  Future<List<TopUp>> fetchList() async {
    // final response = await api.get("https://marcha-api-test-production.up.railway.app/tiket");
    // final response = await api.get("http://udb.ac.id:3000/tiket");
    final response = await api
        .get("https://marcha-api-test-production.up.railway.app/tiket");
    return TopUpRespone.fromJson(response).results;
  }
}
