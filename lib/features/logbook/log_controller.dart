import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';
import 'package:logbook_app_001/services/mongo_service.dart';
import 'package:logbook_app_001/helpers/log_helper.dart';
import 'package:logbook_app_001/services/access_control_service.dart'; 

class LogController {
  final String username;
  
  final currentUser = (id: 'user_001', role: 'Anggota', teamId: 'team_polban_01');

  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  LogController(this.username);

  Future<void> initDatabase() async {
    isLoading.value = true; 
    try {
      await LogHelper.writeLog("CONTROLLER: Memulai inisialisasi...", source: "log_controller.dart");

      await MongoService().connect(username).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception("Koneksi Cloud Timeout. Periksa sinyal/IP Whitelist."),
      );

      await loadFromDisk(); 
      await LogHelper.writeLog("CONTROLLER: Data berhasil dimuat.", source: "log_controller.dart");
    } catch (e) {
      await LogHelper.writeLog("CONTROLLER: Error - $e", level: 1);
      rethrow;
    } finally {
      isLoading.value = false; 
    }
  }

  Future<void> addLog(String title, String desc, String category) async {
    final newLog = LogModel(
      id: ObjectId(), 
      title: title,
      description: desc,
      date: DateTime.now(),
      category: category,
      authorId: currentUser.id,   
      teamId: currentUser.teamId,  
    );
    
    try {
      await MongoService().insertLog(newLog);
      logsNotifier.value = [...logsNotifier.value, newLog];
      filteredLogs.value = logsNotifier.value;
    } catch (e) {
      LogHelper.writeLog("Gagal tambah log: $e", level: 1);
    }
  }

  Future<void> updateLog(int index, String title, String desc, String category) async {
    final logToUpdate = filteredLogs.value[index];
    
    final updatedLog = LogModel(
      id: logToUpdate.id, 
      title: title,
      description: desc,
      date: DateTime.now(), 
      category: category,
      authorId: logToUpdate.authorId, 
      teamId: logToUpdate.teamId,     
    );

    try {
      await MongoService().updateLog(updatedLog);
      final currentLogs = List<LogModel>.from(logsNotifier.value);
      final realIndex = logsNotifier.value.indexOf(logToUpdate);
      
      if (realIndex != -1) {
        currentLogs[realIndex] = updatedLog;
        logsNotifier.value = currentLogs;
        filteredLogs.value = currentLogs;
      }
    } catch (e) {
      LogHelper.writeLog("Gagal update log: $e", level: 1);
    }
  }

  Future<void> removeLog(int index) async {
    final logToRemove = filteredLogs.value[index];
    
    try {
      bool canDelete = AccessControlService.canPerform(currentUser.role, 'delete', isOwner: logToRemove.authorId == currentUser.id);

      if (!canDelete) {
        await LogHelper.writeLog("SECURITY: Unauthorized delete attempt by ${currentUser.id}", level: 1);
        return;
      } 

      if (logToRemove.id != null) {
        await MongoService().deleteLog(logToRemove.id!);
        final currentLogs = List<LogModel>.from(logsNotifier.value);
        currentLogs.removeWhere((item) => item.id == logToRemove.id);
        
        logsNotifier.value = currentLogs;
        filteredLogs.value = List.from(currentLogs);
      }
    } catch (e) {
      LogHelper.writeLog("Gagal hapus log: $e", level: 1);
    }
  }

  Future<void> loadFromDisk() async {
    final cloudData = await MongoService().getLogs();
    logsNotifier.value = cloudData;
    filteredLogs.value = cloudData;
  }

  void searchLog(String query) {
    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value
          .where((log) => log.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}