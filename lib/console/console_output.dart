import 'package:fluent_ui/fluent_ui.dart';

import 'output_type.dart';

class ConsoleOutput {
  final String text;
  final OutputType type;

  ConsoleOutput(
    this.text, {
    OutputType? outputType,
  }) : this.type = outputType ?? OutputType.text;

  InlineSpan get textSpan {
    switch (type) {
      case OutputType.text:
        return _span();
      case OutputType.info:
        return _span(Colors.blue['normal']);
      case OutputType.error:
        return _span(Colors.red['normal']);
    }
  }

  TextSpan _span([Color? color]) => TextSpan(
        text: text + "\n\n\n",
        style: TextStyle(
          color: color,
          fontFamily: 'Roboto Mono',
        ),
      );
}
