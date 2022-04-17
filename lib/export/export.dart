import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../editor/cubit/editor_cubit.dart';
import '../editor/cubit/recursion_cubit.dart';
import '../editor/cubit/recursion_state.dart';
import '../editor/image_editor/file_selection_warning.dart';
import '../editor/image_picker/image_picker_cubit.dart';
import '../editor/image_picker/image_picker_state.dart';
import '../navigation/nav_cubit.dart';

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
            BlocBuilder<ImagePickerCubit, ImagePickerState>(
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
            BlocBuilder<ImagePickerCubit, ImagePickerState>(
              builder: (context, imagePickerState) {
                return BlocBuilder<RecursionCubit, RecursionState>(
                  builder: (context, state) {
                    if (state.isProcessing) return ProgressBar();

                    return FilledButton(
                      child: Text("Exportieren starten"),
                      onPressed: imagePickerState.hasPicked
                          ? () => BlocProvider.of<RecursionCubit>(context)
                              .startProcessing()
                          : null,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text("Neu starten"),
              onPressed: () {
                BlocProvider.of<ImagePickerCubit>(context).clear();
                BlocProvider.of<RecursionCubit>(context).clear();
                BlocProvider.of<EditorCubit>(context).clear();
                BlocProvider.of<NavCubit>(context).previous();
              },
            ),
          ],
        ),
      ),
    );
  }
}
