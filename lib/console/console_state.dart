import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'console_output.dart';

class ConsoleState {
  List<ConsoleOutput> _outputs = [];

  ConsoleState(List<ConsoleOutput> outputs) : _outputs = outputs;

  ConsoleState copyWith(ConsoleOutput output) {
    _outputs.add(output);
    return ConsoleState(_outputs);
  }

  String get text => _outputs.map((e) => e.text).join('\n\n\n');

  RichText get richtext {
    return RichText(
      overflow: TextOverflow.visible,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 16,
          color: Colors.black,
        ),
        children: _outputs.map((e) => e.textSpan).toList(),
      ),
    );
  }
}
