import 'package:flutter/material.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';

import '../../services/network_caller.dart';
import '../../services/network_response.dart';
import '../../services/utils/urls.dart';

class UpdateTaskStatusSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateTaskStatusSheet(
      {super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskStatusSheet> createState() => _UpdateTaskStatusSheetState();
}

class _UpdateTaskStatusSheetState extends State<UpdateTaskStatusSheet> {
  List<String> taskStatusList = ['New', 'Completed', 'Cancelled', 'Progress'];

  late String _selectedTask;

  bool updateTaskInProgress = false;

  @override
  void initState() {
    _selectedTask = widget.task.status!.toLowerCase();
    super.initState();
  }

  Future<void> updateTask(String taskId, String newStatus) async {
    updateTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.updateTask(taskId, newStatus));
    updateTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      widget.onUpdate();
      if (mounted) {
        Navigator.pop(context);
      }
      // getNewTaskList();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Task Status Failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Update Status"),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: taskStatusList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _selectedTask = taskStatusList[index];
                      setState(() {});
                    },
                    title: Text(taskStatusList[index].toUpperCase()),
                    trailing: _selectedTask == taskStatusList[index]
                        ? const Icon(Icons.check)
                        : null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Visibility(
                visible: updateTaskInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ElevatedButton(
                    onPressed: () {
                      updateTask(widget.task.sId!, _selectedTask);
                    }, child: const Text("Update"))),
          )
        ],
      ),
    );
  }
}
