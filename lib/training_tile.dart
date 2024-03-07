import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:run_alarm/dao/training_dao.dart';
import 'package:run_alarm/state/app_state.dart';

class TrainingTile extends StatelessWidget {
  final TrainingDao _training;

  const TrainingTile({
    super.key,
    required TrainingDao training,
  }) : _training = training;

  @override
  Widget build(BuildContext context) {
    var i18n = AppLocalizations.of(context);
    if (i18n == null) {
      throw Exception("No localization");
    }

    return ListTile(
      title: Text(i18n.trainingTileTitle),
      subtitle: Text(i18n.trainingTileSubtitle),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.read<AppState>().removeTraining(_training.id);
        },
      ),
    );
  }
}
