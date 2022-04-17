import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/recursion_cubit.dart';
import 'cubit/recursion_state.dart';
import 'image_picker/step_title.dart';

class RecursionSettings extends StatelessWidget {
  const RecursionSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecursionCubit, ExportSettings>(
      builder: (context, state) {
        String recursionDepthText =
            state.recursionDepth == ExportSettings.maxRecursionDepth
                ? "unendlich"
                : state.recursionDepth.toString() + " Ebenen";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StepTitle(
              title: "Einstellungen zur Rekursion",
              subtitle:
                  "Wähle aus, wie tief die Rekursion maximal werden soll und wie lang das Video am Ende werden soll.",
            ),           
            InfoLabel(
              label: "Tiefe der Rekursion: " + recursionDepthText,
              child: Slider(
                value: state.recursionDepth.toDouble(),
                onChanged: (value) =>
                    BlocProvider.of<RecursionCubit>(context).setDepth(value),
                divisions: ExportSettings.maxRecursionDepth,
                max: ExportSettings.maxRecursionDepth.toDouble(),
                min: 0,
              ),
            ),
            SizedBox(height: 20),
            InfoLabel(
              label: "Länge des Videos: " +
                  (state.frameCount / state.frameRate).floor().toString() +
                  " Sekunden (${state.frameCount} Frames)",
              child: Slider(
                value: state.frameCount.toDouble(),
                onChanged: (value) => BlocProvider.of<RecursionCubit>(context)
                    .setFrameCount(value),
                divisions: ExportSettings.maxFrameCount,
                max: ExportSettings.maxFrameCount.toDouble(),
                min: 1,
              ),
            )
          ],
        );
      },
    );
  }
}
