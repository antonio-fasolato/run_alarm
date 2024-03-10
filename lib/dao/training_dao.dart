import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class TrainingDao {
  static final _log = Logger((TrainingDao).toString());

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
    _log.info(
        'Date from String: ${map['created_at']} -> ${DateFormat("yyyy-MM-dd hh:mm:s").parse(map["created_at"])}');
    var toReturn = TrainingDao(
      map["id"],
      map["title"],
      map["description"],
      DateFormat("yyyy-MM-dd hh:mm:ss").parse(map["created_at"]),
    );

    return toReturn;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
    };
  }
}
