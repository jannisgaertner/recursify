import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

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
            title: () {
              return const DragToMoveArea(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("appTitle"),
                ),
              );
            }(),
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
            displayMode: PaneDisplayMode.auto,
            items: [
              PaneItem(
                icon: Icon(FluentIcons.edit_photo),
                title: Text(
                  'Editor',
                  style: FluentTheme.of(context).typography.titleLarge,
                ),
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
