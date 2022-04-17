import 'dart:developer';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class VideoViewer extends StatefulWidget {
  const VideoViewer({
    Key? key,
    required this.filepath,
  }) : super(key: key);

  final String filepath;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late final Player _player;

  @override
  void initState() {
    _player = Player(id: DateTime.now().microsecondsSinceEpoch);

    _player.open(
      Media.file(File(widget.filepath)),
      autoStart: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      playlistLength: 1,
      player: _player,
    );
  }
}


/*

  late final ChewieController _controller;
  late final VideoPlayerController _videoPlayerController;
  bool _initSuccess = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.filepath),
    );
    await _videoPlayerController.initialize();
    _controller = ChewieController(
      videoPlayerController: _videoPlayerController,
    );
    log("new VideoViewer created for ${widget.filepath}");
    _initSuccess = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_initSuccess) {
      return material.Material(
        child: Chewie(controller: _controller),
      );
    } else {
      return ProgressRing();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _controller.dispose();
    super.dispose();
  }

*/