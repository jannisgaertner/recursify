import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'command/console.dart';
import 'command/console_output_cubit.dart';
import 'command/ffmpeg_api.dart';
import 'navigation/nav_cubit.dart';
import 'navigation/nav_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: true,
    );
    await windowManager.maximize();
    await windowManager.setMinimumSize(const Size(755, 545));
  });

  runApp(RecursifyApp());
}

class RecursifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsoleCubit>(create: (context) => ConsoleCubit()),
        BlocProvider<NavCubit>(create: (context) => NavCubit()),
      ],
      child: FluentApp(
        title: 'Recursify Video Editor',
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

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(), //Console(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () => FfmpegAPI().createVideo(context, 1),
                  child: Text("Video aus Bildern erstellen"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
