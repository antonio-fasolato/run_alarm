import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/database_connection_helper.dart';
import 'package:run_alarm/state/app_state.dart';
import 'package:run_alarm/training_tile.dart';
import 'package:uuid/uuid.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.time}: ${record.level.name} [${record.loggerName}]: ${record.message}');
  });
  Logger.root.level = Level.WARNING;
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    var log = Logger('main');
    log.info("Application started in debug mode");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const RunAlarmApp(),
    ),
  );
}

class RunAlarmApp extends StatelessWidget {
  const RunAlarmApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run alarm',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TrainingList(),
    );
  }
}

class TrainingList extends StatefulWidget {
  const TrainingList({super.key});

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  @override
  Widget build(BuildContext context) {
    var i18n = AppLocalizations.of(context);
    if (i18n == null) {
      throw Exception("No localization");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(i18n.homeTitle),
      ),
      body: Center(
        child: ListView(
          children: context
              .watch<AppState>()
              .trainings
              .map((e) => TrainingTile(training: e))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AppState>().addTraining(TrainingDao.empty());
        },
        tooltip: i18n.homeAdd,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
