import 'package:flutter/material.dart';
import 'package:task_manager_app/services/model/task_list_model.dart';

class TaskListTile extends StatelessWidget {
  final VoidCallback onEdit, onDelete;
  const TaskListTile({
    super.key, required this.data, required this.onEdit, required this.onDelete,
  });

  final TaskData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(data.title ?? "Unknown"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.description ?? " "),
          Text(data.createdDate ?? " "),
          Row(
            children: [
              Chip(
                label: Text(
                  data.status ?? 'New',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
              const Spacer(),
              IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
