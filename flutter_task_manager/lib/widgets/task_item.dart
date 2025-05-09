import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: Icon(
        task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.completed ? Colors.green : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
