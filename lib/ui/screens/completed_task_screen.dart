import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_app/ui/widgets/task_list_tile.dart';
import 'package:task_manager_app/ui/widgets/user_profile_banner.dart';
import '../../services/model/task_list_model.dart';
import '../../services/network_caller.dart';
import '../../services/network_response.dart';
import '../../services/utils/urls.dart';
import '../widgets/screen_background.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool getCompletedListData = false;

  TaskListModel taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCompletedTaskList();
    });
  }

  Future<void> getCompletedTaskList() async {
    getCompletedListData = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.listTaskByStatusCompleted);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Completed Data Load Failed!")));
      }
      //print(response.statusCode);
    }

    getCompletedListData = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if (mounted) {
        setState(() {});
      }
      // getNewTaskList();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to delete data")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Column(
            children: [
              const UserProfileBanner(),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getCompletedTaskList();
                  },
                  child: getCompletedListData
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.separated(
                    itemCount: taskListModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskListTile(
                        data: taskListModel.data![index],
                        onEdit: () {
                          showStatusUpdateBottomSheet(
                              taskListModel.data![index]);
                        }, onDelete: () {
                        deleteTask(taskListModel.data![index].sId!);
                      },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 8,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, updateState) {
          return UpdateTaskStatusSheet(task: task, onUpdate: (){
            getCompletedTaskList();
          });
        });
      },
    );
  }
}
