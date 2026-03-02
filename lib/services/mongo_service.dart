import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logbook_app_001/features/logbook/models/log_model.dart';
import 'package:logbook_app_001/helpers/log_helper.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  Db? _db;
  DbCollection? _collection;
  final String _source = "mongo_service.dart";

  factory MongoService() => _instance;
  MongoService._internal();

  Future<void> connect() async {
    try {
      final dbUri = dotenv.env['MONGODB_URI'];
      if (dbUri == null) throw Exception("MONGODB_URI tidak ditemukan di .env");

      _db = await Db.create(dbUri);
      await _db!.open().timeout(const Duration(seconds: 15)); // Timeout koneksi [cite: 346]
      _collection = _db!.collection('logs');

      await LogHelper.writeLog("DATABASE: Terhubung & Koleksi Siap", source: _source, level: 2);
    } catch (e) {
      await LogHelper.writeLog("DATABASE: Gagal Koneksi - $e", source: _source, level: 1);
      rethrow;
    }
  }

  Future<List<LogModel>> getLogs() async {
    try {
      if (_collection == null) await connect();
      final List<Map<String, dynamic>> data = await _collection!.find().toList();
      return data.map((json) => LogModel.fromMap(json)).toList(); // Ambil dari Cloud [cite: 346]
    } catch (e) {
      await LogHelper.writeLog("ERROR: Fetch Failed - $e", source: _source, level: 1);
      return [];
    }
  }

  Future<void> insertLog(LogModel log) async {
    try {
      if (_collection == null) await connect();
      await _collection!.insertOne(log.toMap()); // Simpan ke Cloud [cite: 346]
      await LogHelper.writeLog("SUCCESS: Data '${log.title}' Saved", source: _source, level: 2);
    } catch (e) {
      await LogHelper.writeLog("ERROR: Insert Failed - $e", source: _source, level: 1);
      rethrow;
    }
  }

  // Tambahkan metode updateLog dan deleteLog sesuai modul Langkah 5 [cite: 346]
}