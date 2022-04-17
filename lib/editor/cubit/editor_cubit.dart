import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/nav_cubit.dart';
import '../image_editor/image_editor.dart';
import '../image_picker/image_picker.dart';
import '../image_picker/image_picker_cubit.dart';
import '../recursion_settings.dart';
import 'editor_step.dart';

class EditorCubit extends Cubit<EditorStep> {
  EditorCubit() : super(EditorStep.first());

  void nextStep(BuildContext context) {
    if (state.index == 0) {
      if (!BlocProvider.of<ImagePickerCubit>(context).isPicked) {
        showSnackbar(
          context,
          Snackbar(
            content: Text('Kein Bild ausgewählt!'),
          ),
        );
        return;
      }
    }
    if (state.index + 1 >= getStepCount(context)) {
      // finished all steps
      BlocProvider.of<NavCubit>(context).next();
    } else {
      // next step
      emit(EditorStep(state.index + 1));
    }
  }

  void prevStep() => emit(EditorStep(state.index - 1));

  Map<String, Widget> _stepsMap(BuildContext context) {
    return {
      'Bild als Grundlage auswählen': ImagePicker(),
      'Bildausschnitt bearbeiten': ImageEditor(),
      'Rekursionstiefe wählen': RecursionSettings(),
    };
  }

  int getStepCount(BuildContext context) => _stepsMap(context).length;

  List<material.Step> getSteps(BuildContext context) {
    return _stepsMap(context)
        .keys
        .map((String key) => material.Step(
              title: Text(key),
              content: _stepsMap(context)[key] ?? Container(),
            ))
        .toList();
  }

  void clear() {
    emit(EditorStep(0));
  }
}
