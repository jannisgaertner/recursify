import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../editor/image_picker/step_title.dart';
import '../export/processing_cubit.dart';

class Viewer extends StatelessWidget {
  const Viewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(maxWidth: 1000),
          child: BlocBuilder<ProcessingCubit, ProcessingState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  StepTitle(
                    title: "erstelltes Video ansehen",
                    subtitle:
                        "Wenn du gerade ein Video mit Recursify erstellt hast, kannst du es dir hier ansehen, indem du auf dem Button drückst. Das Video wird in deinem Standard-Video-Wiedergabe Programm geöffnet.",
                  ),
                  if (state is ProcessingFinished)
                    if (state.filePath != null && state.filePath!.isNotEmpty)
                      FilledButton(
                        child: Text("Datei öffnen"),
                        onPressed: () =>
                            BlocProvider.of<ProcessingCubit>(context)
                                .openVideo(),
                      )
                    //VideoViewer(filepath: state.filePath!)

                    else
                      InfoBar(
                        title: Text(
                            "gerendertes Video kann nicht gefunden werden"),
                        severity: InfoBarSeverity.error,
                      )
                  else
                    InfoBar(
                      title: Text("kein fertig gerendertes Video vorhanden"),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
