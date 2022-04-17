import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'console/console_output_cubit.dart';
import 'editor/editor_cubit.dart';
import 'editor/image_picker/image_picker_cubit.dart';
import 'editor/recursion_cubit.dart';
import 'main.dart';
import 'navigation/nav_cubit.dart';
import 'navigation/nav_view.dart';

class RecursifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsoleCubit>(create: (context) => ConsoleCubit()),
        BlocProvider<NavCubit>(create: (context) => NavCubit()),
        BlocProvider<EditorCubit>(create: (context) => EditorCubit()),
        BlocProvider<ImagePickerCubit>(create: (context) => ImagePickerCubit()),
        BlocProvider<RecursionCubit>(create: (context) => RecursionCubit(null)),
      ],
      child: material.Theme(
        data: material.ThemeData(
          primarySwatch: material.Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.grey[20],
        ),
        child: FluentApp(
          title: title,
          home: NavView(),
          theme: ThemeData(
            brightness: Brightness.light,
            visualDensity: VisualDensity.comfortable,
            accentColor: Colors.teal,
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
