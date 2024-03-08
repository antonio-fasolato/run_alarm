import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/helpers/trainings_helper.dart';
import 'package:run_alarm/state/app_state.dart';

class TrainingTile extends StatefulWidget {
  final TrainingDao _training;

  const TrainingTile({
    super.key,
    required TrainingDao training,
  }) : _training = training;

  @override
  State<TrainingTile> createState() => _TrainingTileState();
}

class _TrainingTileState extends State<TrainingTile> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    var i18n = AppLocalizations.of(context);
    if (i18n == null) {
      throw Exception("No localization");
    }

    return _deleting
        ? ListTile(
            title: Text(i18n.trainingTileConfirmDelete),
            subtitle: Text(i18n.trainingTileConfirmDeleteSubtitle),
            trailing: Wrap(
              spacing: 0,
              children: [
                IconButton(
                  onPressed: () async {
                    var state = context.read<AppState>();
                    var res = await TrainingsHelper.deleteTraining(
                        widget._training.id);
                    if (res == 1) {
                      state.removeTraining(widget._training.id);
                    }
                    setState(() {
                      _deleting = false;
                    });
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _deleting = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          )
        : ListTile(
            title: Text(widget._training.title),
            subtitle: Text(widget._training.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _deleting = true;
                });
              },
            ),
          );
  }
}
