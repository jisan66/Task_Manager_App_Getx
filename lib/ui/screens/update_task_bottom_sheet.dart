import 'package:flutter/material.dart';

import '../../services/model/task_list_model.dart';
import '../../services/network_caller.dart';
import '../../services/network_response.dart';
import '../../services/utils/urls.dart';

class UpdateTaskBottomSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateTaskBottomSheet(
      {super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskBottomSheet> createState() => _UpdateTaskBottomSheetState();
}

class _UpdateTaskBottomSheetState extends State<UpdateTaskBottomSheet> {
  late TextEditingController _titleTEController;

  late TextEditingController _descriptionTEController;

  bool updateTaskInProgress = false;

  @override
  void initState() {
    _titleTEController = TextEditingController(text: widget.task.title);
    _descriptionTEController =
        TextEditingController(text: widget.task.description);
    super.initState();
  }

  Future<void> updateTask() async {
    updateTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> responseBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTask, responseBody);

    updateTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task Updated Successfully")));
      }
      widget.onUpdate();
    }
      else {
        if (mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Task Update Failed!")));
      }
      }
      //print(response.statusCode);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Text("Update Task",
                        style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _titleTEController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: _descriptionTEController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: updateTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          updateTask();
                        },
                        child: const Text("Update")),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
