import 'package:flutter/material.dart';
import 'package:task_manager_app/services/network_caller.dart';
import 'package:task_manager_app/services/network_response.dart';
import 'package:task_manager_app/services/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/user_profile_banner.dart';

import 'new_task_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEcontroller = TextEditingController();
  final TextEditingController _descriptionTEcontroller =
      TextEditingController();
  bool _addNewTaskInProgress = false;

  Future<void> addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> responseBody = {
      "title": _titleTEcontroller.text.trim(),
      "description": _descriptionTEcontroller.text.trim(),
      "status": "New"
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTask, responseBody);

    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      _titleTEcontroller.clear();
      _descriptionTEcontroller.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task added Successfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Task add Failed!")));
      }
      //print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Text("Add New Task",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _titleTEcontroller,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: _descriptionTEcontroller,
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
                        visible: _addNewTaskInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              addNewTask();
                              Navigator.pop(context,MaterialPageRoute(builder: (context)=>const NewTaskScreen()));
                            },
                            child: const Icon(Icons.arrow_forward)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
