import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../models/project.dart';
import '../providers/project_task_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Project? initialProject;

  final Function(Project) onAdd;

  AddProjectDialog({required this.onAdd, this.initialProject});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();
  String _label = "Add";

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialProject?.name ?? '';
    _label = widget.initialProject != null ? "Edit" : _label;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$_label Project'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Project Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(_label),
          onPressed: () {
            var newProject = Project(id: DateTime.now().toString(), name: _controller.text, isDefault: false);
            widget.onAdd(newProject);
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