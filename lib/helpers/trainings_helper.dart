import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/database_connection_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TrainingsHelper {
  static Future<List<TrainingDao>> getAllTrainings() async {
    Database db = await DatabaseConnectionHelper().connect();

    var res = await db.query('TRAININGS', orderBy: "created_at");
    return res.map((row) => TrainingDao.fromMap(row)).toList();
  }
}
