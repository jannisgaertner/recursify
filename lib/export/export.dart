import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../editor/cubit/editor_cubit.dart';
import '../editor/cubit/recursion_cubit.dart';
import '../editor/image_editor/file_selection_warning.dart';
import '../editor/image_picker/image_picker_cubit.dart';
import '../editor/image_picker/image_picker_state.dart';
import '../navigation/nav_cubit.dart';
import 'processing_cubit.dart';

class Export extends StatelessWidget {
  const Export({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              "rekursives Video erstellen",
              style: FluentTheme.of(context).typography.title,
            ),
            Text(
              "Überprüfe deine Angaben und starte das Exportieren deines Videos.",
              style: FluentTheme.of(context).typography.body,
            ),
            SizedBox(height: 20),
            BlocBuilder<ImagePickerCubit, ProcessableImageFile>(
              builder: (context, state) {
                if (!state.hasPicked) return FileSelectionWarning();

                return material.DataTable(
                  columns: [
                    material.DataColumn(label: Text("Einstellung")),
                    material.DataColumn(label: Text("Wert")),
                  ],
                  rows: RecursionCubit.titles
                      .map(
                        (e) => material.DataRow(
                          cells: [
                            material.DataCell(Text(e)),
                            material.DataCell(
                              Text(BlocProvider.of<RecursionCubit>(context)
                                  .getValue(e, context)),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                );
              },
            ),
            SizedBox(height: 20),
            BlocBuilder<ImagePickerCubit, ProcessableImageFile>(
              builder: (context, imagePickerState) {
                return BlocBuilder<ProcessingCubit, ProcessingState>(
                  builder: (context, state) {
                    List<Widget> children = [];
                    if (state is ProcessingInitial) {
                      children = [
                        FilledButton(
                          child: Text("Exportieren starten"),
                          onPressed: imagePickerState.hasPicked
                              ? () => BlocProvider.of<ProcessingCubit>(context)
                                  .start(context)
                              : null,
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          child: Text("Neu starten"),
                          onPressed: () => _restart(context),
                        ),
                      ];
                    } else if (state is ProcessingCurrently) {
                      double? val =
                          state.progress != null ? state.progress! * 100 : null;
                      children = [
                        ProgressBar(value: val),
                        SizedBox(height: 10),
                        Center(child: Text(state.label)),
                      ];
                    } else if (state is ProcessingError) {
                      children = [
                        InfoBar(
                          title: Text("Ein Fehler ist aufgetreten!"),
                          severity: InfoBarSeverity.error,
                          content: Text(
                            "Die Verarbeitung konnte nicht erfolgreich abgeschlossen werden." +
                                "\nBitte überprüfe deine Einstellungen und versuche es erneut.",
                          ),
                          isLong: true,
                          action: Button(
                            child: Text("neu starten"),
                            onPressed: () => _restart(context),
                          ),
                          onClose: null,
                        ),
                      ];
                    } else if (state is ProcessingFinished) {
                      children = [
                        InfoBar(
                          title: Text(state.success
                              ? "Video erfolgreich exportiert!"
                              : "Video konnte nicht exportiert werden!"),
                          severity: state.success
                              ? InfoBarSeverity.success
                              : InfoBarSeverity.error,
                          isLong: true,
                          action: Row(
                            children: [
                              FilledButton(
                                child: Text("Video ansehen"),
                                onPressed: () =>
                                    BlocProvider.of<ProcessingCubit>(context)
                                        .openVideo(),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                child: Text("neu starten"),
                                onPressed: () => _restart(context),
                              ),
                            ],
                          ),
                        ),
                      ];
                    }

                    return Column(
                      children: children,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _restart(BuildContext context) {
    BlocProvider.of<ImagePickerCubit>(context).clear();
    BlocProvider.of<RecursionCubit>(context).clear();
    BlocProvider.of<EditorCubit>(context).clear();
    BlocProvider.of<NavCubit>(context).previous();
    BlocProvider.of<ProcessingCubit>(context).clear();
  }
}
