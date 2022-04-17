import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_picker/image_picker.dart';
import 'recursion_cubit.dart';

class RecursionSettings extends StatelessWidget {
  const RecursionSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecursionCubit, RecursionState>(
      builder: (context, state) {
        String recursionDepthText =
            state.recursionDepth == RecursionState.maxRecursionDepth
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
                divisions: RecursionState.maxRecursionDepth,
                max: RecursionState.maxRecursionDepth.toDouble(),
                min: 0,
              ),
            ),
            SizedBox(height: 20),
            InfoLabel(
              label: "Länge des Videos: ${state.frameCount} Frames",
              child: Slider(
                value: state.frameCount.toDouble(),
                onChanged: (value) => BlocProvider.of<RecursionCubit>(context)
                    .setFrameCount(value),
                divisions: RecursionState.maxFrameCount,
                max: RecursionState.maxFrameCount.toDouble(),
                min: 1,
              ),
            )
          ],
        );
      },
    );
  }
}
