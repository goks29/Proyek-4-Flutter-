import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';
import 'package:logbook_app_001/services/mongo_service.dart';
import 'package:logbook_app_001/helpers/log_helper.dart';

class LogController {
  final String username;
  // logsNotifier menyimpan data utama, filteredLogs untuk fitur pencarian [cite: 372]
  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);

  LogController(this.username);

  // 1. Menambah data ke Cloud (Async)
  Future<void> addLog(String title, String desc, String category) async {
    final newLog = LogModel(
      id: ObjectId(), // Identitas unik untuk MongoDB [cite: 288]
      title: title,
      description: desc,
      date: DateTime.now(),
      category: category,
    );

    try {
      // Kirim ke MongoDB Atlas [cite: 372]
      await MongoService().insertLog(newLog);
      
      // Update UI Lokal jika berhasil
      logsNotifier.value = [...logsNotifier.value, newLog];
      filteredLogs.value = logsNotifier.value;
      
      await LogHelper.writeLog("SUCCESS: Tambah data ke Cloud", source: "log_controller.dart");
    } catch (e) {
      await LogHelper.writeLog("ERROR: Gagal tambah data - $e", level: 1);
    }
  }

  // 2. Memperbarui data di Cloud (HOTS: Sinkronisasi Terjamin)
  Future<void> updateLog(int index, String title, String desc, String category) async {
    final logToUpdate = filteredLogs.value[index];
    final updatedLog = LogModel(
      id: logToUpdate.id, // ID harus tetap sama agar MongoDB mengenali dokumen ini [cite: 372]
      title: title,
      description: desc,
      date: DateTime.now(),
      category: category,
    );

    try {
      // Jalankan update di MongoService (Tunggu konfirmasi Cloud) [cite: 372]
      await MongoService().updateLog(updatedLog);
      
      final currentLogs = List<LogModel>.from(logsNotifier.value);
      final realIndex = logsNotifier.value.indexOf(logToUpdate);
      
      if (realIndex != -1) {
        currentLogs[realIndex] = updatedLog;
        logsNotifier.value = currentLogs;
        filteredLogs.value = currentLogs;
      }
      
      await LogHelper.writeLog("SUCCESS: Update Cloud Berhasil", source: "log_controller.dart");
    } catch (e) {
      await LogHelper.writeLog("ERROR: Update Gagal - $e", level: 1);
    }
  }

  // 3. Menghapus data dari Cloud
  Future<void> removeLog(int index) async {
    final logToRemove = filteredLogs.value[index];
    
    try {
      if (logToRemove.id != null) {
        // Hapus data di MongoDB Atlas [cite: 372]
        await MongoService().deleteLog(logToRemove.id!);
        
        final currentLogs = List<LogModel>.from(logsNotifier.value);
        currentLogs.remove(logToRemove);
        logsNotifier.value = currentLogs;
        filteredLogs.value = logsNotifier.value;
        
        await LogHelper.writeLog("SUCCESS: Hapus Cloud Berhasil", source: "log_controller.dart");
      }
    } catch (e) {
      await LogHelper.writeLog("ERROR: Hapus Gagal - $e", level: 1);
    }
  }

  // 4. Mengambil data dari Cloud (Bukan SharedPreferences lagi) [cite: 372]
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