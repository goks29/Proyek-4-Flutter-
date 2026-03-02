import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';

class LogController {
  final String username;
  late final String _storageKey;

  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);

  LogController(this.username) {
    _storageKey =  '${username}user_logs_data';
    loadFromDisk(); 
  }

  void addLog(String title, String desc, String category) {
    final newLog = LogModel(title: title, description: desc, date:DateTime.now().toString(), category: category);
    logsNotifier.value = [...logsNotifier.value, newLog];
    filteredLogs.value = logsNotifier.value;
    saveToDisk();
  }

  void updateLog(int index, String title, String desc, String category) {
    final logToUpdate = filteredLogs.value[index];
    final realIndex = logsNotifier.value.indexOf(logToUpdate);

    if (realIndex != -1) {
      final currentLogs = List<LogModel>.from(logsNotifier.value);
      currentLogs[index] = LogModel(title: title, description: desc, date: DateTime.now().toString(),category: category);
      logsNotifier.value = currentLogs;
      filteredLogs.value = currentLogs;
      saveToDisk();
    }
  }

  void removeLog(int index) {
    final logToRemove = filteredLogs.value[index];
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    currentLogs.remove(logToRemove);
    logsNotifier.value = currentLogs;
    filteredLogs.value = logsNotifier.value;
    saveToDisk(); 
  }

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(logsNotifier.value.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      logsNotifier.value = decoded.map((e) => LogModel.fromMap(e)).toList();
      filteredLogs.value = logsNotifier.value;
    }
  }

  void searchLog(String query) {
    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value.where(
          (log) => log.title.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }
}

