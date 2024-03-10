import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:run_alarm/components/training_popup.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/trainings_helper.dart';
import 'package:run_alarm/state/app_state.dart';
import 'package:run_alarm/training_tile.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({super.key});

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  late TrainingDao? Function() _submitTraining;

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
              onPressed: () async {
                var t = _submitTraining();
                if (t != null) {
                  var nav = Navigator.of(context);
                  await TrainingsHelper.save(t);
                  await _loadTrainings();
                  nav.pop();
                }
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
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 200),
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