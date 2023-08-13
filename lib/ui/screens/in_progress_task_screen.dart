import 'package:flutter/material.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';
import 'package:task_manager_app/services/network_caller.dart';
import 'package:task_manager_app/services/network_response.dart';
import 'package:task_manager_app/services/utils/urls.dart';
import 'package:task_manager_app/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_app/ui/widgets/task_list_tile.dart';
import 'package:task_manager_app/ui/widgets/user_profile_banner.dart';

import '../widgets/screen_background.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({Key? key}) : super(key: key);

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  TaskListModel taskListModel = TaskListModel();

  bool _getInProgressInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProgressTaskList();
    });
  }

  Future<void> getProgressTaskList() async {
    _getInProgressInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.listTaskByStatusProgress);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Progress Data Load Failed!")));
      }
      //print(response.statusCode);
    }

    _getInProgressInProgress = false;
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
                    getProgressTaskList();
                  },
                  child: _getInProgressInProgress
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
          return UpdateTaskStatusSheet(task: task, onUpdate: () {
            getProgressTaskList();
          });
        });
      },
    );
  }
}
