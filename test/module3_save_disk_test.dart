

import 'package:flutter_test/flutter_test.dart';
import 'package:logbook_app_001/features/logbook/log_controller.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';

void main() {

  group('Module 3 - Save Data to Disk (with storage & step)', () {
    late LogController controller;
    const username = "admin";
    const password = "123";
    const title = "dummy";
    const description = "bahas proyek";
    const kosong = "";

    setUp(() async {
      // (1) setup (arrange, build)
      controller = LogController(username,password);
      controller.logsNotifier.value = [
        LogModel(
          id: '1', 
          title: 'dummy', 
          description: 'yow', 
          date: DateTime.now(), 
          category: 'Software', 
          authorId: username, 
          teamId: 'team_01', 
          isPublic: true
        ),
        LogModel(
          id: '2', 
          title: 'rapat', 
          description: 'bahas proyek', 
          date: DateTime.now(), 
          category: 'Management', 
          authorId: username, 
          teamId: 'team_01', 
          isPublic: true
        )
      ];
    });

    test('Mencari data berdasarkan keyword nama judul', () {
      // (2) exercise set up data
      controller.searchLog(title);
      var hasilPencaharian = controller.filteredLogs.value;
      expect(hasilPencaharian.length, 1, reason: 'Harusnya cuma 1 data yang ketemu');

      String judulYangDitemukan = hasilPencaharian.first.title;
      expect(title, judulYangDitemukan, reason: 'judul sesuai dengan hasil pencaharian');
    });

    test('Mencari data berdasarkan keyword nama deskripsi', () {
      // (2) exercise set up data
      controller.searchLog(description);
      var hasilPencaharian = controller.filteredLogs.value;
      expect(hasilPencaharian.length, 1, reason: 'Harusnya cuma 1 data yang ketemu');

      String judulYangDitemukan = hasilPencaharian.first.description;
      expect(description, judulYangDitemukan, reason: 'deskripsi sesuai dengan hasil pencaharian');
    });

    test('Mencari data dengan keyword kosong', () {
      // (2) exercise set up data
      controller.searchLog(kosong);
      var hasilPencaharian = controller.filteredLogs.value;
      expect(hasilPencaharian.length, 2, reason: 'Harusnya ada 2 data yang ketemu');
    });
  });
}
