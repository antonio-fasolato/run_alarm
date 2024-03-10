import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:run_alarm/components/training_popup.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/trainings_helper.dart';
import 'package:run_alarm/state/app_state.dart';
import 'package:run_alarm/training_tile.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
  void Function() submitFunction,
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

class TrainingList extends StatefulWidget {
  const TrainingList({super.key});

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  late void Function() _submitTraining;

  @override
  void initState() {
    super.initState();

    _loadTrainings();
  }

  _loadTrainings() async {
    context
        .read<AppState>()
        .setTrainings(await TrainingsHelper.getAllTrainings());
  }

  _buildPopup() {
    var i18n = AppLocalizations.of(context);
    if (i18n == null) {
      throw Exception("No localization");
    }

    var page = WoltModalSheetPage(
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                height: 20,
                width: double.infinity,
                child: Center(
                  child: Text(i18n.cancel),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submitTraining();
                Navigator.of(context).pop();
              },
              child: SizedBox(
                height: 20,
                width: double.infinity,
                child: Center(
                  child: Text(i18n.ok),
                ),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text(i18n.homeNewTrainig),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        padding: const EdgeInsets.all(16),
        icon: const Icon(Icons.close),
      ),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 400),
          child: TrainingPopup(
            builder: (context, submitFunction) {
              _submitTraining = submitFunction;
            },
          )),
    );

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (context) => [page],
    );
  }

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
        onPressed: () => _buildPopup(),
        tooltip: i18n.homeAdd,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
