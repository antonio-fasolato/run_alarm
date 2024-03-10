import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:run_alarm/components/training_list.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/state/app_state.dart';

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

typedef TrainingPopupBuilder = void Function(
  BuildContext context,
  TrainingDao? Function() submitFunction,
);

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

