import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recursion_cubit.dart';
import '../cubit/recursion_state.dart';
import '../image_picker/image_picker_cubit.dart';
import '../image_picker/image_picker_state.dart';

class AreaSelector extends StatelessWidget {
  const AreaSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ProcessableImageFile>(
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
                  BlocBuilder<RecursionCubit, ExportSettings>(
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
