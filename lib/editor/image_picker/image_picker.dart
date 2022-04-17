import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recursion_cubit.dart';
import '../cubit/recursion_state.dart';

import 'image_picker_cubit.dart';
import 'image_picker_state.dart';
import 'step_title.dart';

class ImagePicker extends StatelessWidget {
  const ImagePicker({Key? key}) : super(key: key);

  static const Map<String, Size> resolutions = {
    'Standard Definition SD': Size(720, 567),
    'High Definition HD': Size(1280, 720),
    'High Definition Full-HD': Size(1920, 1080),
  };

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
          BlocBuilder<ImagePickerCubit, ProcessableImageFile>(
            builder: (context, state) {
              Widget child;

              if (state.hasPicked) {
                child = Row(
                  children: [
                    IconButton(
                      icon: Icon(FluentIcons.delete),
                      onPressed: () =>
                          BlocProvider.of<ImagePickerCubit>(context).clear(),
                    ),
                    Flexible(child: Text(state.file!.path)),
                  ],
                );
              } else {
                child = Button(
                  child: Text("Dateipicker öffnen"),
                  onPressed: () =>
                      BlocProvider.of<ImagePickerCubit>(context).pickImage(),
                );
              }

              return InfoLabel(
                label: "Bildauswahl",
                child: child,
              );
            },
          ),
          SizedBox(height: 20),
          BlocBuilder<RecursionCubit, ExportSettings>(
            builder: (context, s) {
              return InfoLabel(
                label: "Videoauflösung auswählen",
                child: DropDownButton(
                  title: Text("ausgewählt: ${s.size.width} x ${s.size.height}"),
                  items: resolutions.keys.map(
                    (String e) {
                      Size res = resolutions[e]!;
                      return DropDownButtonItem(
                        onTap: () => BlocProvider.of<RecursionCubit>(context)
                            .setResolution(res),
                        title: Text(e + " (${res.width} x s${res.height})"),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
