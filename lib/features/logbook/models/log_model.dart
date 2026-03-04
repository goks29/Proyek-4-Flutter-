import 'package:mongo_dart/mongo_dart.dart';

class LogModel {
  final ObjectId? id;
  final String title;
  final DateTime date;
  final String description;
  final String category;

  LogModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.category,
  });

  factory LogModel.fromMap(Map<String,dynamic> map) {
    DateTime parsedData = DateTime.now();
    if (map['date'] is DateTime) {
      parsedData = (map['date'] as DateTime).toLocal();
    } else if (map['date'] is String) {
      parsedData = DateTime.parse(map['date']).toLocal();
    }

    return LogModel(
      id: map['_id'] as ObjectId?,
      title: map['title'] ?? '',
      date: parsedData,
      description: map['description'] ?? '',
      category: map['category'] ?? 'Pribadi'
    );
  }

  Map<String,dynamic> toMap() {
    return {
      '_id': id ?? ObjectId(),
      'title' : title,
      'date' : date,
      'description' : description,
      'category' : category,
    };
  }
}