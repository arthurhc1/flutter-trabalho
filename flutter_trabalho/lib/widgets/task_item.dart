import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_trabalho/model/task.dart';
import 'package:flutter_trabalho/providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Dismissible(
      key: Key(task.id.toString()),
      onDismissed: (_) => provider.removeTask(task),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => provider.toggleTaskCompletion(task),
        ),
      ),
    );
  }
}
