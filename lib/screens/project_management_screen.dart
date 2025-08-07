import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_task_provider.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Projects and Tasks')),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          // Lists for managing projects and tasks would be implemented here
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteProject(project.id);
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
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}
