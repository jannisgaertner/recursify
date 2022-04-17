import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

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
