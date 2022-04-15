import 'dart:developer';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import 'package:recursify/command/console_output_cubit.dart';
import 'package:recursify/command/ffmpeg_api.dart';

import 'command/console.dart';
import 'navigation/nav_cubit.dart';

void main() {
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
      ),
    );
  }
}

class NavView extends StatelessWidget {
  const NavView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, index) {
        return NavigationView(
          appBar: NavigationAppBar(
            title: Text('Nice App Title :)'),
            actions: Row(
              children: [
                IconButton(
                  icon: Icon(FluentIcons.close_pane),
                  onPressed: () {},
                ),
              ],
            ),
            automaticallyImplyLeading: true,
          ),
          pane: NavigationPane(
            selected: index,
            onChanged: (i) => BlocProvider.of<NavCubit>(context).setIndex(i),
            displayMode: PaneDisplayMode.auto,
            items: [
              PaneItem(
                icon: Icon(FluentIcons.edit_photo),
                title: const Text('Editor'),
              ),
              PaneItem(
                icon: Icon(FluentIcons.export),
                title: const Text('Exportieren'),
              ),
            ],
          ),
          content: NavigationBody.builder(
            index: index,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return AppBody();
                default:
                  return Center(
                    child: Text("Fehler"),
                  );
              }
            },
          ),
        );
      },
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
          child: Console(),
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
