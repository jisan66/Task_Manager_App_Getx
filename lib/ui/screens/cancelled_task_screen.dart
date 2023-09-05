import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/widgets/task_list_tile.dart';
import 'package:task_manager_app/ui/widgets/user_profile_banner.dart';

import '../../services/state_managers/get_cancelled_controller.dart';
import '../widgets/screen_background.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final GetCancelledTaskController _getCancelledTaskController = Get.find<
      GetCancelledTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCancelledTaskController.getCancelledTaskList();
    });
  }

  // Future<void> getCompletedTaskList() async {
  //   getCompletedListData = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //   final NetworkResponse response =
  //   await NetworkCaller().getRequest(Urls.listTaskByStatusCompleted);
  //   if (response.isSuccess) {
  //     taskListModel = TaskListModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Completed Data Load Failed!")));
  //     }
  //     //print(response.statusCode);
  //   }
  //
  //   getCompletedListData = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> deleteTask(String taskId) async {
  //   final NetworkResponse response =
  //   await NetworkCaller().getRequest(Urls.deleteTask(taskId));
  //   if (response.isSuccess) {
  //     taskListModel.data!.removeWhere((element) => element.sId == taskId);
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     // getNewTaskList();
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Failed to delete data")));
  //     }
  //   }
  // }


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
              GetBuilder<GetCancelledTaskController>(
                  builder: (_) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _getCancelledTaskController.getCancelledTaskList();
                        },
                        child: _getCancelledTaskController.getCancelledTask
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : ListView.separated(
                          itemCount: _getCancelledTaskController.taskListModel
                              .data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              data: _getCancelledTaskController.taskListModel
                                  .data![index],
                              onEdit: () {},
                              onDelete: () {
                                _getCancelledTaskController.deleteTask(
                                    _getCancelledTaskController.taskListModel
                                        .data![index].sId!);
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
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}