import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TrainingDao {
  String id;
  String title;
  String description;
  DateTime createdAt;

  TrainingDao(
    this.id,
    this.title,
    this.description,
    this.createdAt,
  );

  TrainingDao.empty()
      : this(
          const Uuid().v4().toString(),
          '',
          '',
          DateTime.now(),
        );

  factory TrainingDao.fromMap(Map<String, dynamic> map) {
    var toReturn = TrainingDao(
      map["id"],
      map["title"],
      map["description"],
      DateFormat("yyyy-MM-dd").parse(map["created_at"]),
    );

    return toReturn;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "issuing_date": DateFormat("yyyy-MM-dd").format(createdAt),
    };
  }
}
