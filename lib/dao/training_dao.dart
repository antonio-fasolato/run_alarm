import 'package:uuid/uuid.dart';

class TrainingDao {
  String id;
  String title;
  String description;
  DateTime createdAt;

  TrainingDao({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  TrainingDao.empty()
      : this(
          id: const Uuid().v4().toString(),
          title: '',
          description: '',
          createdAt: DateTime.now(),
        );
}
