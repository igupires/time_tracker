import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../providers/project_task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? initialTask;

  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd, this.initialTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();
  String _label = "Add";

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialTask?.name ?? '';
    _label = widget.initialTask != null ? "Edit" : _label;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$_label Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Task Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newTask = Task(id: DateTime.now().toString(), name: _controller.text, isDefault: false);
            widget.onAdd(newTask);
            // Clear the input field for next input
            _controller.clear();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}