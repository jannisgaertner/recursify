import 'package:fluent_ui/fluent_ui.dart';

class StepTitle extends StatelessWidget {
  const StepTitle({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: FluentTheme.of(context).typography.title,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: FluentTheme.of(context).typography.body,
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
