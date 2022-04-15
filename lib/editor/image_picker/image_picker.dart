import 'dart:io';

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
          Text(
            "Wähle eine Datei aus",
            style: FluentTheme.of(context).typography.title,
          ),
          Text(
            "Das ausgewählte Bild wird daraufhin als Grundlage für ein rekursives Video verwendet.",
            style: FluentTheme.of(context).typography.body,
          ),
          SizedBox(height: 20),
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
