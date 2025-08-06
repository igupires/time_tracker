import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/project.dart';

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void addTask(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void deleteTask(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }
}