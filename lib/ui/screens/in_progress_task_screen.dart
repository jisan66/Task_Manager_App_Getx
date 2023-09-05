import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';
import 'package:task_manager_app/services/state_managers/get_in_progress_controller.dart';
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
  final GetInProgressController _getInProgressController =
      Get.find<GetInProgressController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInProgressController.getInProgressList();
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
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              GetBuilder<GetInProgressController>(builder: (_) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getInProgressController.getInProgressList();
                    },
                    child: _getInProgressController.getInProgressListData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            itemCount: _getInProgressController
                                    .taskListModel.data?.length ??
                                0,
                            itemBuilder: (context, index) {
                              return TaskListTile(
                                data: _getInProgressController
                                    .taskListModel.data![index],
                                onEdit: () {
                                  showStatusUpdateBottomSheet(
                                      _getInProgressController
                                          .taskListModel.data![index]);
                                },
                                onDelete: () {
                                  _getInProgressController.deleteTask(
                                      _getInProgressController
                                          .taskListModel.data![index].sId!);
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                height: 8,
                              );
                            },
                          ),
                  ),
                );
              }),
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
          return UpdateTaskStatusSheet(
              task: task,
              onUpdate: () {
                _getInProgressController.getInProgressList();
              });
        });
      },
    );
  }
}
