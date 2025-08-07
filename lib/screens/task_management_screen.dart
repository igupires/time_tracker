import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_task_provider.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Projects and Tasks')),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          // Lists for managing projects and tasks would be implemented here
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.projects[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteTask(task.id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red[300]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new project or task
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
