import 'package:flutter/material.dart';
import 'package:task_manager_app/services/model/summary_count_model.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';
import 'package:task_manager_app/services/network_caller.dart';
import 'package:task_manager_app/services/network_response.dart';
import 'package:task_manager_app/services/utils/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_task.dart';
import 'package:task_manager_app/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/summary_card.dart';
import 'package:task_manager_app/ui/widgets/task_list_tile.dart';
import 'package:task_manager_app/ui/widgets/user_profile_banner.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _isSummaryCountInProgress = false, getNewListData = false;

  SummaryCountModel summaryCountModel = SummaryCountModel();

  TaskListModel taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSummaryCount();
      getNewTaskList();
    });
  }

  Future<void> getSummaryCount() async {
    _isSummaryCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Status Count Failed!")));
      }
    }

    _isSummaryCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTaskList() async {
    getNewListData = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.listTaskByStatusNew);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New Task Load Failed!")));
      }
      //print(response.statusCode);
    }

    getNewListData = false;
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

  Future<void> updateTask(String taskId, String newStatus) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.updateTask(taskId, newStatus));
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: _isSummaryCountInProgress
                    ? const LinearProgressIndicator()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
              ),
              _isSummaryCountInProgress
                  ? const Center(
                      child: LinearProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: summaryCountModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return SummaryCard(
                              title:
                                  summaryCountModel.data![index].sId ?? "New",
                              number: summaryCountModel.data![index].sum ?? 0,
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getNewTaskList();
                  },
                  child: _isSummaryCountInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              data: taskListModel.data![index],
                              onEdit: () {
                                // showBottomEditSheet(taskListModel.data![index]);
                                showStatusUpdateBottomSheet(
                                    taskListModel.data![index]);
                              },
                              onDelete: () {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showBottomEditSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskBottomSheet(
          task: task,
          onUpdate: () {
            getNewTaskList();
          },
        );
      },
    );
  }

  void showStatusUpdateBottomSheet(TaskData task) {


    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, updateState) {
          return UpdateTaskBottomSheet(task: task, onUpdate: (){
            getNewTaskList();
          });
        });
      },
    );
  }
}
