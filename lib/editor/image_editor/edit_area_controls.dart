import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recursion_cubit.dart';
import '../cubit/recursion_state.dart';

class EditAreaControls extends StatelessWidget {
  const EditAreaControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecursionCubit, RecursionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoLabel(
              label:
                  "Größe der Rekursion: ${(state.relChildSize * 100).toInt()} %",
              child: Slider(
                value: state.relChildSize,
                onChanged: (value) => BlocProvider.of<RecursionCubit>(context)
                    .setRelChildSize(value),
                min: 0.0,
                max: 1.0,
                divisions: 100,
              ),
            ),
            InfoLabel(
              label:
                  "Verschiebung in x-Richtung: ${(state.relChildOffsetX * 100).toInt()} %",
              child: Slider(
                value: state.relChildOffsetX,
                onChanged: (value) => BlocProvider.of<RecursionCubit>(context)
                    .setRelChildOffsetX(value),
                min: 0.0,
                max: 1.0,
                divisions: 100,
              ),
            ),
            InfoLabel(
              label:
                  "Verschiebung in y-Richtung: ${(state.relChildOffsetY * 100).toInt()} %",
              child: Slider(
                value: state.relChildOffsetY,
                onChanged: (value) => BlocProvider.of<RecursionCubit>(context)
                    .setRelChildOffsetY(value),
                min: 0.0,
                max: 1.0,
                divisions: 100,
              ),
            ),
          ],
        );
      },
    );
  }
}
