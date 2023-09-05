import 'package:get/get.dart';
import '../model/summary_count_model.dart';
import '../network_caller.dart';
import '../network_response.dart';
import '../utils/urls.dart';

class SummaryCountController extends GetxController {
  bool _isSummaryCountInProgress = false;

  bool get isSummaryCountInProgress => _isSummaryCountInProgress;

  SummaryCountModel _summaryCountModel = SummaryCountModel();

  SummaryCountModel get summaryCountModel => _summaryCountModel;

  Future<bool> getSummaryCount() async {
    _isSummaryCountInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    _isSummaryCountInProgress = false;
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
      return false;
    }
  }
}
