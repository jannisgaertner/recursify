import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recursify/editor/image_picker/image_picker_cubit.dart';
import 'package:window_manager/window_manager.dart';

import 'command/console_output_cubit.dart';
import 'editor/editor_cubit.dart';
import 'navigation/nav_cubit.dart';
import 'navigation/nav_view.dart';

const title = 'Recursify Video Editor';
const Size minWindowSize = const Size(755, 545);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.maximize();
    await windowManager.setMinimumSize(minWindowSize);
  });

  runApp(RecursifyApp());

  doWhenWindowReady(() {
    appWindow.minSize = minWindowSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = title;
    appWindow.show();
  });
}

class RecursifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsoleCubit>(create: (context) => ConsoleCubit()),
        BlocProvider<NavCubit>(create: (context) => NavCubit()),
        BlocProvider<EditorCubit>(create: (context) => EditorCubit()),
        BlocProvider<ImagePickerCubit>(create: (context) => ImagePickerCubit()),
      ],
      child: FluentApp(
        title: title,
        home: NavView(),
        theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.comfortable,
          accentColor: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
