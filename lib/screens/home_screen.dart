import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/providers/project_task_provider.dart';
import '../providers/time_entry_provider.dart';
import '../screens/add_time_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Entries'),
        backgroundColor: Colors.deepOrange[500],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "All Entries"),
            Tab(text: "Grouped By Project"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange[400]),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.deepOrange[200]),
              title: Text('Manage Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.deepOrange[200]),
              title: Text('Manage Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [buildAllTasks(context), buildTaskByProject(context)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
        backgroundColor: Colors.deepOrange[500],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget buildAllTasks(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Entries",
                    style: TextStyle(color: Colors.grey[800], fontSize: 32),
                  ),
                  Icon(Icons.no_sim_outlined),
                  Text(
                    "Click the + button to record new time entries.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: provider.entries.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 5.0);
          },
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            return Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: Consumer<ProjectTaskProvider>(
              builder: (context, taskProvider, child) {
                int project = taskProvider.projects.indexWhere(
                  (e) => e.id == entry.projectId,
                );
                int task = taskProvider.tasks.indexWhere(
                  (e) => e.id == entry.taskId,
                );
                String projectName = "<empty>";
                String taskName = "<empty>";
                if (task != -1) {
                  taskName = taskProvider.tasks[task].name;
                }
                if (project != -1) {
                  projectName = taskProvider.projects[project].name;
                }

                return Material(
                  color: Colors.deepOrange[50],
                  elevation: 2.0, // Adjust the elevation for shadow intensity
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ), // Adjust the radius as needed
                  ),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        '[$projectName] $taskName - ${entry.totalTime} hours',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('ProjectID: ${entry.projectId}'),
                                Text(' -- '),
                                Text('TaskID: ${entry.taskId}'),
                              ]
                            ),
                        Text('Date: ${entry.date.toString()}'),
                        Text('Notes: ${entry.notes}'),
                      ],
                    ),
                    onTap: () {
                      // This could open a detailed view or edit screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTimeEntryScreen(initialTimeEntry: entry),
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () {
                        provider.deleteTimeEntry(entry.id);
                      },
                      icon: Icon(Icons.delete, color: Colors.red[300]),
                    ),
                  ),
                );
              },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTaskByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Entries",
                    style: TextStyle(color: Colors.grey[800], fontSize: 32),
                  ),
                  Icon(Icons.no_sim_outlined),
                  Text(
                    "Click the + button to record new time entries.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        var grouped = groupBy(provider.entries, (TimeEntry t) => t.projectId);
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
            child: ListView(
              children: grouped.entries.map((entry) {
                String projectName = getProjectNameById(context, entry.key);
                double total = entry.value.fold(
                  0.0,
                  (double prev, TimeEntry el) => prev + el.totalTime,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsGeometry.all(8.0),
                      child: Text(
                        "$projectName - Total of ${total.toStringAsFixed(2)} hours",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                      shrinkWrap:
                          true, // necessary to integrate a ListView within another ListView
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        TimeEntry te = entry.value[index];
                        String taskName = getTaskNameById(context, te.taskId);
                        return ListTile(
                          leading: Icon(
                            Icons.monetization_on,
                            color: Colors.white12,
                          ),
                          title: Text(
                            "[TASK - $taskName] - ${te.totalTime}h - Note: ${te.notes}",
                          ),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy').format(te.date),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // home_screen.dart
  String getProjectNameById(BuildContext context, String projectId) {
    var project = Provider.of<ProjectTaskProvider>(
      context,
      listen: false,
    ).projects.firstWhere((project) => project.id == projectId);
    return project.name;
  }

  String getTaskNameById(BuildContext context, String taskId) {
    var task = Provider.of<ProjectTaskProvider>(
      context,
      listen: false,
    ).tasks.firstWhere((task) => task.id == taskId);
    return task.name;
  }
}
