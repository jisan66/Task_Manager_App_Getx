import 'package:get/get.dart';

import '../model/task_list_model.dart';
import '../network_caller.dart';
import '../network_response.dart';
import '../utils/urls.dart';

class GetNewTaskController extends GetxController {
  bool _getNewListData = false;

  bool get getNewListData => _getNewListData;

  TaskListModel _taskListModel = TaskListModel();

  TaskListModel get taskListModel => TaskListModel();

  Future<bool> getNewTaskList() async {
    _getNewListData = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.listTaskByStatusNew);
    _getNewListData = false;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      return true;
    } else {
      update();
      return false;
    }
  }
}
