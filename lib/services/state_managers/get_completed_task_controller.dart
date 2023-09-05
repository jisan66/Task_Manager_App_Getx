import 'package:get/get.dart';
import '../model/task_list_model.dart';
import '../network_caller.dart';
import '../network_response.dart';
import '../utils/urls.dart';

class GetCompletedTaskController extends GetxController {
  bool _getCompletedListData = false;

  bool get getCompletedListData => _getCompletedListData;

  TaskListModel _taskListModel = TaskListModel();

  TaskListModel get taskListModel => _taskListModel;


  Future<bool> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      taskListModel.data!.removeWhere((element) => element.sId == taskId);
      update();
      return true;
      // getNewTaskList();
    } else {
      update();
      return false;
    }
  }

  Future<bool> getCompletedTaskList() async {
    _getCompletedListData = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.listTaskByStatusCompleted);
    _getCompletedListData = false;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
      return false;
      //print(response.statusCode);
    }
  }
}
