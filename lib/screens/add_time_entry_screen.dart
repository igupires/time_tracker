import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialTimeEntry;

  const AddTimeEntryScreen({Key? key, this.initialTimeEntry}) : super(key: key);

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String lastId = '';
  String projectId = '1';
  String taskId = '1';
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';
  String _label = "Add";
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    lastId = widget.initialTimeEntry?.id ?? '';
    projectId = widget.initialTimeEntry?.projectId ?? '';
    taskId = widget.initialTimeEntry?.taskId ?? '';
    totalTime = widget.initialTimeEntry?.totalTime ?? 0.0;
    date = widget.initialTimeEntry?.date ?? DateTime.now();
    notes = widget.initialTimeEntry?.projectId ?? '';
    _editing = widget.initialTimeEntry != null;
    _label = _editing ? "Edit" : _label;
  }

  @override
  Widget build(BuildContext context) {
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);
    projectId = (projectTaskProvider.projects.any((p) => p.id == projectId)
        ? projectId
        : (projectTaskProvider.projects.isNotEmpty
              ? projectTaskProvider.projects.first.id
              : null))!;
    taskId = (projectTaskProvider.tasks.any((p) => p.id == taskId)
        ? taskId
        : (projectTaskProvider.tasks.isNotEmpty
              ? projectTaskProvider.tasks.first.id
              : null))!;

    return Scaffold(
      appBar: AppBar(title: Text('$_label Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (String? newValue) {
                  setState(() {
                    projectId = newValue ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Project'),
                items: projectTaskProvider.projects
                    .map<DropdownMenuItem<String>>((Project project) {
                      return DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(project.name),
                      );
                    })
                    .toList(),
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (String? newValue) {
                  setState(() {
                    taskId = newValue ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Task'),
                items: projectTaskProvider.tasks.map<DropdownMenuItem<String>>((
                  Task task,
                ) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: totalTime.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                initialValue: notes,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                  }
                  return null;
                },
                onSaved: (value) => notes = value!,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (_editing) {
                        timeEntryProvider.editTimeEntry(
                          TimeEntry(
                            id: lastId, // Simple ID generation
                            projectId: projectId,
                            taskId: taskId,
                            totalTime: totalTime,
                            date: date,
                            notes: notes,
                          ),
                        );
                      } else {
                        timeEntryProvider.addTimeEntry(
                          TimeEntry(
                            id: DateTime.now()
                                .toString(), // Simple ID generation
                            projectId: projectId,
                            taskId: taskId,
                            totalTime: totalTime,
                            date: date,
                            notes: notes,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(_label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
