import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../command/console.dart';
import '../editor/editor.dart';
import '../export/export.dart';
import '../main.dart';
import 'nav_cubit.dart';

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
            //leading: FlutterLogo(),
            automaticallyImplyLeading: false,
            title: DragToMoveArea(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  title,
                  style: FluentTheme.of(context).typography.title,
                ),
              ),
            ),
            actions: DragToMoveArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: 138,
                    child: WindowCaption(
                      brightness: FluentTheme.of(context).brightness,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pane: NavigationPane(
            selected: index,
            onChanged: (i) => BlocProvider.of<NavCubit>(context).setIndex(i),
            displayMode: PaneDisplayMode.top,
            //scrollController: ScrollController(initialScrollOffset: 0),
            items: [
              PaneItem(
                icon: Icon(FluentIcons.edit_photo),
                title: const Text('Editor'),
              ),
              PaneItem(
                icon: Icon(FluentIcons.export),
                title: const Text('Exportieren'),
              ),
              PaneItem(
                icon: Icon(FluentIcons.code),
                title: const Text('Konsolenausgabe'),
              ),
            ],
          ),
          content: NavigationBody(
            index: index,
            children: [
              Editor(),
              Export(),
              Console(),
            ],
          ),
        );
      },
    );
  }
}
