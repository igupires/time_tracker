import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  TimeEntryProvider(this.storage) {
    // _loadTimeEntriesFromStorage();
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntriesToStorage();
    notifyListeners();
  }

  void _loadTimeEntriesFromStorage() async {
    // await storage.ready;
    var storedEntries = storage.getItem('entries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveTimeEntriesToStorage() {
    storage.setItem(
      'entries',
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }
}
