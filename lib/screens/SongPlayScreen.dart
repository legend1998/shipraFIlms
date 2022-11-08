// ignore_for_file: file_names

import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shiprafilms/data/Song.dart';
import 'package:shiprafilms/main.dart';

class SongPlayScreen extends StatefulWidget {
  const SongPlayScreen({Key? key, required this.song}) : super(key: key);
  final Song song;

  @override
  State<SongPlayScreen> createState() => _SongPlayScreenState();
}

class _SongPlayScreenState extends State<SongPlayScreen> {
  double position = 0;
  bool isPlaying = true;
  List<AudioServiceRepeatMode> repeatModes = [
    AudioServiceRepeatMode.none,
    AudioServiceRepeatMode.all,
    AudioServiceRepeatMode.one,
  ];
  List<IconData> repeatIcons = [
    Icons.repeat,
    Icons.repeat_on_outlined,
    Icons.repeat_one
  ];
  PageController controller = PageController(viewportFraction: 0.95);
  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
        iconSize: 64.0,
        onPressed: onPressed,
      );

  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));

  @override
  void initState() {
    audioHandler.setSpeed(1.0);
    FirebaseAnalytics.instance.logLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: controller,
        padEnds: false,
        scrollDirection: Axis.vertical,
        children: [playScreen(), playlistPage()],
      )),
    );
  }

  Widget playlistPage() => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            child: StreamBuilder<List<MediaItem>>(
              stream: audioHandler.queue,
              builder: (context, snapshot) {
                final mlist = snapshot.data ?? [];
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: mlist
                      .map((e) => ListTile(
                            onTap: () {
                              //   audioHandler.
                              audioHandler.playMediaItem(e);
                            },
                            title: Text(e.title),
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(e.artUri.toString())),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      );

  Widget playScreen() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                return Column(
                  children: [
                    Text(
                      mediaItem?.title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 100,
                                spreadRadius: 50,
                                color: Colors.cyan.shade400)
                          ],
                          borderRadius: BorderRadius.circular(125),
                          image: DecorationImage(
                              image: NetworkImage(
                                  mediaItem?.artUri.toString() ?? ""),
                              fit: BoxFit.fill)),
                    ),
                  ],
                );
              },
            ),
          ),
          StreamBuilder<AudioProcessingState>(
            stream: audioHandler.playbackState
                .map((state) => state.processingState)
                .distinct(),
            builder: (context, snapshot) {
              final processingState =
                  snapshot.data ?? AudioProcessingState.idle;
              return Text(describeEnum(processingState));
            },
          ),
          StreamBuilder<MediaState>(
            stream: _mediaStateStream,
            builder: (context, snapshot) {
              final mediaState = snapshot.data;
              return Slider(
                min: 0,
                activeColor: Colors.white,
                max:
                    mediaState?.mediaItem?.duration?.inSeconds.toDouble() ?? 10,
                value: mediaState?.position.inSeconds.toDouble() ?? 0,
                onChanged: (newPosition) {
                  audioHandler.seek(Duration(seconds: newPosition.toInt()));
                },
              );
            },
          ),
          StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: ((context, snapshot) {
                final state = snapshot.data;
                AudioServiceShuffleMode shuffleMode =
                    state?.shuffleMode ?? AudioServiceShuffleMode.none;
                AudioServiceRepeatMode mode =
                    state?.repeatMode ?? AudioServiceRepeatMode.none;
                int repeatModeIndex = repeatModes.indexOf(mode);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          audioHandler.setShuffleMode(
                              mode == AudioServiceShuffleMode.all
                                  ? AudioServiceShuffleMode.none
                                  : AudioServiceShuffleMode.all);
                        },
                        icon: Icon(
                          shuffleMode == AudioServiceShuffleMode.all
                              ? Icons.shuffle_on
                              : Icons.shuffle,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          audioHandler.setRepeatMode(repeatModeIndex + 1 > 2
                              ? repeatModes[0]
                              : repeatModes[repeatModeIndex + 1]);

                          setState(() {});
                        },
                        icon: Icon(repeatIcons[repeatModeIndex],
                            color: Colors.white)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite, color: Colors.white)),
                  ],
                );
              })),
          const SizedBox(
            height: 50,
          ),
          StreamBuilder<bool>(
            stream: audioHandler.playbackState
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;
              return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(142, 14, 99, 75),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _button(Icons.fast_rewind, audioHandler.skipToPrevious),
                      if (playing)
                        _button(Icons.pause, audioHandler.pause)
                      else
                        _button(Icons.play_arrow, audioHandler.play),
                      _button(Icons.fast_forward, audioHandler.skipToNext),
                    ],
                  ));
            },
          ),
        ],
      );
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}
