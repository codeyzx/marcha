import 'dart:async';

import 'package:marcha_branch/api/api_response.dart';
import 'package:marcha_branch/cubit/topup_repositroy.dart';
import 'package:marcha_branch/models/topup.dart';

class TopUpBloc {
  late TopUpRepository repository;
  StreamController<ApiResponse<List<TopUp>>> listController =
      StreamController<ApiResponse<List<TopUp>>>();

  StreamSink<ApiResponse<List<TopUp>>> get listSink => listController.sink;
  Stream<ApiResponse<List<TopUp>>> get listStream => listController.stream;

  TopUpBloc() {
    repository = TopUpRepository();
    fetchList();
  }

  fetchList() async {
    listSink.add(ApiResponse.loading('Memuat TopUp'));
    try {
      List<TopUp> data = await repository.fetchList();
      listSink.add(ApiResponse.completed(data));
    } catch (e) {
      listSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    listController.close();
  }
}
