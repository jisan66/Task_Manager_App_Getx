import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';
import 'package:task_manager_app/services/state_managers/get_new_task_controller.dart';
import 'package:task_manager_app/services/state_managers/summary_count_controller.dart';
import 'package:task_manager_app/ui/screens/add_new_task.dart';
import 'package:task_manager_app/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager_app/ui/screens/update_task_status_sheet.dart';
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

  final SummaryCountController _summaryCountController =
  Get.find<SummaryCountController>();

  final GetNewTaskController _getNewTaskController = Get.find<GetNewTaskController>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getSummaryCount();
      _getNewTaskController.getNewTaskList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Column(
            children: [
              const UserProfileBanner(),
              GetBuilder<SummaryCountController>(builder: (_) {
                if (_summaryCountController.isSummaryCountInProgress) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _summaryCountController
                          .summaryCountModel.data?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return SummaryCard(
                          title: _summaryCountController
                              .summaryCountModel.data![index].sId ??
                              "New",
                          number: _summaryCountController
                              .summaryCountModel.data![index].sum ??
                              0,
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
              }),
              GetBuilder<GetNewTaskController>(
                builder: (_) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _getNewTaskController.getNewTaskList();
                      },
                      child: _summaryCountController.isSummaryCountInProgress
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.separated(
                        itemCount: _getNewTaskController.taskListModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: _getNewTaskController.taskListModel.data![index],
                            onEdit: () {
                              // showBottomEditSheet(taskListModel.data![index]);
                              showStatusUpdateBottomSheet(
                                  _getNewTaskController.taskListModel.data![index]);
                            },
                            onDelete: () {
                              _getNewTaskController.deleteTask(_getNewTaskController.taskListModel.data![index].sId!);
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
            _getNewTaskController.getNewTaskList();
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
          return UpdateTaskStatusSheet(
              task: task,
              onUpdate: () {
                _getNewTaskController.getNewTaskList();
              });
        });
      },
    );
  }
}