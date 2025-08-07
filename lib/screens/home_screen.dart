import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
        children: [
          buildAllTasks(context),
          buildTaskByProject(context),
        ],
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
        splashColor: Colors.orange,
      ),
    );
  }

  Widget buildAllTasks(BuildContext context) {
    return Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.entries.isEmpty) {
            return Center(
              child: Text("Click the + button to record new time entries.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return ListTile(
                title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                subtitle: Text(
                  '${entry.date.toString()} - Notes: ${entry.notes}',
                ),
                onTap: () {
                  // This could open a detailed view or edit screen
                  showDialog(
                    context: context,
                    builder: (context) => AddTimeEntryScreen(),
                  );
                },
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
            return Center(
              child: Text("Click the + button to record new time entries.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18)),
            );
          }

          var grouped = groupBy(provider.entries, (TimeEntry t) => t.projectId);
          return ListView(
            children: grouped.entries.map((entry) {
              String projectName = getProjectNameById(context,entry.key);
              double total = entry.value.fold(0.0, (double prev, TimeEntry el) => prev + el.totalTime);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                  padding: EdgeInsetsGeometry.all(8.0),
                    child: Text(
                      "$projectName - Total \$${total.toStringAsFixed(2)} hours",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  
                ],
              );
            }).toList(),
          );
        },
      );
  }

  // home_screen.dart
  String getProjectNameById(BuildContext context, String projectId) {
    var category = Provider.of<ProjectTaskProvider>(context, listen: false)
        .projects
        .firstWhere((cat) => cat.id == projectId);
    return category.name;
  }
}
