import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/database_connection_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TrainingsHelper {
  static Future<List<TrainingDao>> getAllTrainings() async {
    Database db = await DatabaseConnectionHelper().connect();

    var res = await db.query('TRAININGS', orderBy: "created_at");
    return res.map((row) => TrainingDao.fromMap(row)).toList();
  }

  static Future<int> deleteTraining(String id) async {
    Database db = await DatabaseConnectionHelper().connect();

    return await db.delete('TRAININGS', where: "id = ?", whereArgs: [id]);
  }

  static Future<int> save(TrainingDao t) async {
    Database db = await DatabaseConnectionHelper().connect();

    var res = await db.query('TRAININGS', where: 'id = ?', whereArgs: [t.id]);
    if (res.isEmpty) {
      return await db.insert(
        'TRAININGS',
        t.toMap(),
      );
    } else {
      return await db.update(
        'TRAININGS',
        t.toMap(),
        where: 'id = ?',
        whereArgs: [t.id],
      );
    }
  }
}
