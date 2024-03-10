import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrainingPopup extends StatefulWidget {
  const TrainingPopup({super.key});

  @override
  State<TrainingPopup> createState() => _TrainingPopupState();
}

class _TrainingPopupState extends State<TrainingPopup> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var i18n = AppLocalizations.of(context);
    if (i18n == null) {
      throw Exception("No localization");
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              label: Text(i18n.trainingPopupTitle),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                (value ?? '').isEmpty ? i18n.trainigPopupTitleValidation : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              label: Text(i18n.trainingPopupDescription),
            ),
          ),
        ],
      ),
    );
  }
}
