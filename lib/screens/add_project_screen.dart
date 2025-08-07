import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String projectId = '1';
  String taskId = '1';
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: projectId,
              onChanged: (String? newValue) {
                setState(() {
                  projectId = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Project'),
              items: projectTaskProvider.projects.map<DropdownMenuItem<String>>(
                (Project project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                },
              ).toList(),
            ),
            DropdownButtonFormField<String>(
              value: taskId,
              onChanged: (String? newValue) {
                setState(() {
                  taskId = newValue!;
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some notes';
                }
                return null;
              },
              onSaved: (value) => notes = value!,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Provider.of<TimeEntryProvider>(
                    context,
                    listen: false,
                  ).addTimeEntry(
                    TimeEntry(
                      id: DateTime.now().toString(), // Simple ID generation
                      projectId: projectId,
                      taskId: taskId,
                      totalTime: totalTime,
                      date: date,
                      notes: notes,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
