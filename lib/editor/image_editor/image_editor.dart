import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../image_picker/image_picker_cubit.dart';

class ImageEditor extends StatelessWidget {
  const ImageEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, File?>(
      builder: (context, state) {
        if (state == null)
          return InfoBar(
            title: Text("Keine Datei ausgewählt"),
            content: Text(
              'Wähle im ersten Schritt zuerst eine gültige Datei aus, um hier fortfahren zu können.',
            ),
            severity: InfoBarSeverity.info,
          );
        return Container(
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            child: Image.file(state),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
