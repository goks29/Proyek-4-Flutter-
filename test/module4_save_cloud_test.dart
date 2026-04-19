import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:logbook_app_001/features/logbook/models/log_model.dart';
import 'package:logbook_app_001/services/mongo_service.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(); 

    dotenv.env.addAll({
      'MONGODB_URI': 'mongodb://mock_db_url',
      'ENV': 'development',
    });
  });

  group('Module 4 - Save Data to Cloud Service', () {
    test('sistem menolak proses getLogs jika username kosong', () async {
      final mongoService = MongoService(); 

      final action = () async => await mongoService.getLogs();
      expect(
        action,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message', contains('Username kosong'),
          ),
        ),
        reason: 'Harus melempar Exception "Username kosong" karena layanan cloud belum diinisialisasi dengan username',
      );
    });

    test('sistem menolak proses insertLog jika username kosong', () async {
      final mongoService = MongoService();
      
      final dummyLog = LogModel(
        title: 'Judul Catatan Test',
        description: 'Deskripsi pengujian data',
        date: DateTime.now(),
        category: 'Software',
        authorId: 'admin',
        teamId: 'team_polban_01',
        isPublic: true
      );

      final action = () => mongoService.insertLog(dummyLog);

      expect(
        action,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Username kosong'),
          ),
        ),
        reason: 'Harus melempar Exception "Username kosong" saat mencoba menyimpan data ke cloud tanpa koneksi/username',
      );
    });

    test('memastikan error selain username kosong dari modul getLogs', () async {
      final mongoService = MongoService();
  
      try {
        await mongoService.connect('admin'); 
      } catch (_) {}

      final action = () => mongoService.getLogs();

      expect(
        action,
        throwsA(
          isNot(
            predicate((e) => e.toString().contains('Username kosong')),
          ),
        ),
        reason: 'Error tidak boleh lagi "Username kosong" setelah username di-set',
      );
    }); 

  });
}