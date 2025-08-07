import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/task.dart';
import '../models/project.dart';

class ProjectTaskProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Project> _projects = [
    Project(id: '1', name: 'Angular Project', isDefault: true),
    Project(id: '2', name: 'React Project', isDefault: true),
    Project(id: '3', name: 'Vue.js Project', isDefault: true),
    Project(id: '4', name: 'Flutter Project', isDefault: true),
    Project(id: '5', name: 'Go Project', isDefault: true),
  ];

  List<Task> _tasks = [
    Task(id: '1', name: 'Layout', isDefault: true),
    Task(id: '2', name: 'Plan', isDefault: true),
    Task(id: '3', name: 'Develop', isDefault: true),
    Task(id: '4', name: 'Verify', isDefault: true),
    Task(id: '5', name: 'Deploy', isDefault: true),
  ];

  ProjectTaskProvider(this.storage) {
    // _loadProjectsFromStorage();
    // _loadTasksFromStorage();
  }

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  void addProject(Project project) {
    _projects.add(project);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void addTask(Project project) {
    _projects.add(project);
    _saveTasksToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void _loadProjectsFromStorage() async {
    // await storage.ready;
    var storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      _projects = List<Project>.from(
        (storedProjects as List).map((item) => Project.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _loadTasksFromStorage() async {
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (storedTasks as List).map((item) => Task.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveProjectsToStorage() {
    storage.setItem(
      'projects',
      jsonEncode(_projects.map((e) => e.toJson()).toList()),
    );
  }

  void _saveTasksToStorage() {
    storage.setItem(
      'tasks',
      jsonEncode(_tasks.map((e) => e.toJson()).toList()),
    );
  }
}
