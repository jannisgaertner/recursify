import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../image_picker/image_picker_cubit.dart';

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
        return SizedBox(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                child: Image.file(state.file!),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              SizedBox(width: 20),
              AreaSelector(),
            ],
          ),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: FluentTheme.of(context).accentColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
        builder: (context, state) {
          if (state.size == null) {
            return Text("Größe des Bildes wird ermittelt...");
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  AspectRatio(
                    aspectRatio: state.aspectRatio,
                    child: Center(
                      child: Text(
                        "Bereich auswählen",
                        style: FluentTheme.of(context).typography.body,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    height: 150,
                    // width: constraints.maxWidth - 10,
                    top: 10,
                    child: AspectRatio(
                      aspectRatio: state.aspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FluentTheme.of(context).accentColor,
                            width: 2,
                          ),
                          color: FluentTheme.of(context)
                              .accentColor
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
