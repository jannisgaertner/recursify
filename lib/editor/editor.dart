import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'editor_cubit.dart';

class Editor extends StatelessWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: material.Material(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1000),
          child: BlocBuilder<EditorCubit, EditorStep>(
            builder: (context, state) {
              return material.Stepper(
                currentStep: state.index,
                elevation: 0.0,
                type: material.StepperType.horizontal,
                onStepContinue: () =>
                    BlocProvider.of<EditorCubit>(context).nextStep(context),
                onStepCancel: () =>
                    BlocProvider.of<EditorCubit>(context).prevStep(),
                steps: BlocProvider.of<EditorCubit>(context).getSteps(context),
              );
            },
          ),
        ),
      ),
    );
  }
}
