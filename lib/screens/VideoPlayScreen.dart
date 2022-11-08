import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiprafilms/data/Video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  const VideoPlayScreen({Key? key, required this.video}) : super(key: key);
  final Video video;

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController animationController;
  late Stream videoPositionStream;
  bool completed = false;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // audioHandler.stop();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _controller = VideoPlayerController.network(widget.video.url!)
      ..initialize().then((value) {
        _controller.play();
      });

    chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        zoomAndPan: true,
        allowedScreenSleep: false,
        looping: true,
        showControlsOnInitialize: false,
        deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ));
  }

  @override
  void dispose() async {
    super.dispose();
    chewieController.dispose();
    animationController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 1.6, child: Chewie(controller: chewieController)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.video.title!,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
