import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/nav_cubit.dart';

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
      action: Button(
        onPressed: () => BlocProvider.of<NavCubit>(context).previous(),
        child: Text("Zum Editor"),
      ),
      isLong: true,
      severity: InfoBarSeverity.info,
    );
  }
}
