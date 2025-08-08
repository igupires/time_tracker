import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/add_task_dialog.dart';
import '../providers/project_task_provider.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
        backgroundColor: Colors.deepOrange[300],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 238, 232),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          // Lists for managing projects and tasks would be implemented here
          return ListView.separated(
            itemCount: provider.tasks.length,
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 5.0);
            },
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
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
                    title: Text(task.name),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddTaskDialog(
                          initialTask: task,
                          onAdd: (newTask) {
                            Provider.of<ProjectTaskProvider>(
                              context,
                              listen: false,
                            ).editTask(newTask, task);
                            Navigator.pop(
                              context,
                            ); // Close the dialog after adding the new tag
                          },
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () {
                        provider.deleteTask(task.id);
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
            builder: (context) => AddTaskDialog(
              onAdd: (newTask) {
                Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                ).addTask(newTask);
              },
            ),
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
