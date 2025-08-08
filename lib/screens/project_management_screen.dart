import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/add_project_dialog.dart';
import '../providers/project_task_provider.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects'),
        backgroundColor: Colors.deepOrange[300],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 238, 232),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          // Lists for managing projects and tasks would be implemented here
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: Material(
                  color: Colors.deepOrange[50],
                  elevation: 2.0, // Adjust the elevation for shadow intensity
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ), // Adjust the radius as needed
                  ),
                  child: ListTile(
                    title: Text(project.name),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddProjectDialog(
                          initialProject: project,
                          onAdd: (newProject) {
                            Provider.of<ProjectTaskProvider>(
                              context,
                              listen: false,
                            ).editProject(newProject, project);
                            Navigator.pop(
                              context,
                            ); // Close the dialog after adding the new tag
                          },
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () {
                        provider.deleteProject(project.id);
                      },
                      icon: Icon(Icons.delete, color: Colors.red[300]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange[500],
        foregroundColor: Colors.white,
        onPressed: () {
          // Add new project or task
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                ).addProject(newProject);
                Navigator.pop(
                  context,
                ); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}
