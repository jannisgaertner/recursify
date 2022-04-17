import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../image_picker/image_picker.dart';
import '../image_picker/image_picker_cubit.dart';
import '../recursion_cubit.dart';

class ImageEditor extends StatelessWidget {
  const ImageEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      builder: (context, state) {
        if (state.file == null)
          return InfoBar(
            title: Text("Keine Datei ausgewählt"),
            content: Text(
              'Wähle im ersten Schritt zuerst eine gültige Datei aus, um hier fortfahren zu können.',
            ),
            severity: InfoBarSeverity.info,
          );
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StepTitle(
              title: "Rekursionsweise bearbeiten",
              subtitle:
                  "Wähle den Bildbereich aus, den das rekursiv in sich eingefügte Frame einnehmen soll.",
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(flex: 2, child: AreaSelector()),
                Flexible(flex: 1, child: Container()),
              ],
            ),
            SizedBox(height: 60),
            EditAreaControls()
          ],
        );
      },
    );
  }
}

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

class AreaSelector extends StatelessWidget {
  const AreaSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      builder: (context, state) {
        if (state.size == null) {
          return Text("Größe des Bildes wird ermittelt...");
        }

        return AspectRatio(
          aspectRatio: state.aspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: FluentTheme.of(context).accentColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      child: Image.file(state.file!),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  BlocBuilder<RecursionCubit, RecursionState>(
                    builder: (context, recursion) {
                      return Positioned(
                        left: constraints.maxWidth * recursion.relChildOffsetX,
                        height: constraints.maxHeight * recursion.relChildSize,
                        width: constraints.maxWidth * recursion.relChildSize,
                        top: constraints.maxHeight * recursion.relChildOffsetY,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FluentTheme.of(context).accentColor,
                            width: 2,
                          ),
                          color: FluentTheme.of(context)
                              .accentColor
                                .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

