import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_picker_cubit.dart';

class ImagePicker extends StatelessWidget {
  const ImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepTitle(
            title: "Wähle eine Datei aus",
            subtitle:
                "Das ausgewählte Bild wird daraufhin als Grundlage für ein rekursives Video verwendet.",
          ),          
          Button(
            child: Text("Bild auswählen"),
            onPressed: () =>
                BlocProvider.of<ImagePickerCubit>(context).pickImage(),
          ),
          SizedBox(height: 20),
          BlocBuilder<ImagePickerCubit, ImagePickerState>(
            builder: (context, state) {
              if (state.file == null) return Text("Keine Datei ausgewählt");
              return Row(
                children: [
                  IconButton(
                    icon: Icon(FluentIcons.delete),
                    onPressed: () =>
                        BlocProvider.of<ImagePickerCubit>(context).clear(),
                  ),
                  Flexible(child: Text(state.file!.path)),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class StepTitle extends StatelessWidget {
  const StepTitle({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: FluentTheme.of(context).typography.title,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: FluentTheme.of(context).typography.body,
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
