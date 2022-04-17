import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../image_picker/image_picker_cubit.dart';
import '../image_picker/image_picker_state.dart';
import '../image_picker/step_title.dart';
import 'area_selector.dart';
import 'edit_area_controls.dart';
import 'file_selection_warning.dart';


class ImageEditor extends StatelessWidget {
  const ImageEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      builder: (context, state) {
        if (!state.hasPicked) return FileSelectionWarning();
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

