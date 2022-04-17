import 'package:fluent_ui/fluent_ui.dart';

class FileSelectionWarning extends StatelessWidget {
  const FileSelectionWarning({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoBar(
      title: Text("Keine Datei ausgewählt"),
      content: Text(
        'Wähle im ersten Schritt zuerst eine gültige Datei aus, um hier fortfahren zu können.',
      ),
      severity: InfoBarSeverity.info,
    );
  }
}
