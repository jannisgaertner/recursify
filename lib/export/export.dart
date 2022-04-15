import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recursify/editor/recursion_cubit.dart';

class Export extends StatelessWidget {
  const Export({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
            DataTable(
              columns: [
                DataColumn(label: Text("Einstellung")),
                DataColumn(label: Text("Wert")),
              ],
              rows: RecursionCubit.titles
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e)),
                        DataCell(
                          Text(BlocProvider.of<RecursionCubit>(context)
                              .getValue(e, context)),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            BlocBuilder<RecursionCubit, RecursionState>(
              builder: (context, state) {
                if (state.isProcessing) return ProgressBar();

                return FilledButton(
                  child: Text("Exportieren starten"),
                  onPressed: () => BlocProvider.of<RecursionCubit>(context)
                      .startProcessing(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
