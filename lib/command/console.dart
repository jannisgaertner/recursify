import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer';

import 'console_output_cubit.dart';

class Console extends StatelessWidget {
  Console({
    Key? key,
  }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          BlocBuilder<ConsoleCubit, ConsoleState>(
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    state.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto Mono',
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(20),
            child: TextButton.icon(
              onPressed: () => BlocProvider.of<ConsoleCubit>(context).clear(),
              icon: Icon(Icons.delete),
              label: Text("Konsolenausgabe leeren"),
            ),
          ),
        ],
      ),
    );
  }
}
