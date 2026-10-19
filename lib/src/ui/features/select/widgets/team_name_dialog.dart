import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../../core/resources/translations_constant.dart';

/// Pide el nombre del equipo. Devuelve `null` si se cancela.
/// Se usa al guardar y al renombrar (migrado de "Renombrar Equipo").
Future<String?> showTeamNameDialog(
  BuildContext context, {
  required String title,
  String initialValue = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _TeamNameDialog(title: title, initialValue: initialValue),
  );
}

class _TeamNameDialog extends StatefulWidget {
  const _TeamNameDialog({required this.title, required this.initialValue});

  final String title;
  final String initialValue;

  @override
  State<_TeamNameDialog> createState() => _TeamNameDialogState();
}

class _TeamNameDialogState extends State<_TeamNameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 30,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: TEAM_NAME.i18n(),
          hintText: TEAM_NAME_HINT.i18n(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(ACTION_CANCEL.i18n()),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (_, value, __) => FilledButton(
            onPressed: value.text.trim().isEmpty ? null : _submit,
            child: Text(ACTION_SAVE.i18n()),
          ),
        ),
      ],
    );
  }
}
