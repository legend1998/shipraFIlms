// ignore_for_file: file_names
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiprafilms/data/Song.dart';
import 'package:shiprafilms/main.dart';
import 'package:shiprafilms/screens/HomeScreen.dart';
import 'package:shiprafilms/screens/MusicScreen.dart';
import 'package:shiprafilms/screens/SongPlayScreen.dart';
import 'package:shiprafilms/screens/VideosScreen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  String selected = "Home";
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
            decoration: const BoxDecoration(color: Color(0xFF043942)),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bottomCard("Home", Icons.home, 0),
                bottomCard("Music", Icons.music_note, 1),
                bottomCard("Videos", Icons.video_call, 2)
              ],
            )),
        body: Stack(
          children: [
            IndexedStack(
              index: _current,
              children: const [HomeScreen(), MusicScreen(), VideosScreen()],
            ),
            StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: ((context, snapshot) {
                  MediaItem? item = snapshot.data;
                  if (item?.title != null) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 45),
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 10,
                                    color: Colors.black45)
                              ],
                              gradient: const LinearGradient(
                                  colors: [Colors.teal, Colors.cyan],
                                  end: Alignment.topCenter,
                                  begin: Alignment.bottomCenter),
                              borderRadius: BorderRadius.circular(3)),
                          child: Row(
                            children: [
                              FadeInImage(
                                  placeholder:
                                      const AssetImage("images/loading.gif"),
                                  image: NetworkImage(
                                      item?.artUri.toString() as String)),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Song s = Song(
                                      url: item?.id,
                                      duration: item?.duration?.inMilliseconds,
                                      icon: item?.artUri.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SongPlayScreen(song: s)));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item?.title ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    StreamBuilder<AudioProcessingState>(
                                      stream: audioHandler.playbackState
                                          .map((state) => state.processingState)
                                          .distinct(),
                                      builder: (context, snapshot) {
                                        final processingState = snapshot.data ??
                                            AudioProcessingState.idle;
                                        return Text(
                                          describeEnum(processingState),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )),
                              StreamBuilder<bool>(
                                stream: audioHandler.playbackState
                                    .map((state) => state.playing)
                                    .distinct(),
                                builder: (context, snapshot) {
                                  final playing = snapshot.data ?? false;
                                  return IconButton(
                                      constraints: const BoxConstraints(),
                                      iconSize: 30,
                                      onPressed: () {
                                        if (playing) {
                                          audioHandler.pause();
                                        } else {
                                          audioHandler.play();
                                        }
                                      },
                                      icon: Icon(
                                        playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ));
                                },
                              ),
                            ],
                          )),
                    );
                  } else {
                    return const SizedBox(
                      height: 1,
                    );
                  }
                })),
          ],
        ));
  }

  Widget bottomCard(String name, IconData icon, int index) {
    return InkWell(
        onTap: (() => setState(() {
              selected = name;
              _current = index;
            })),
        child: Container(
            decoration: selected == name
                ? BoxDecoration(
                    boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 0,
                            color: Color(0xff09C1DE))
                      ],
                    color: const Color(0xff044853),
                    borderRadius: BorderRadius.circular(6))
                : null,
            padding: const EdgeInsets.all(5),
            child: Row(children: [
              Icon(icon, color: Colors.white),
              if (selected == name)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
            ])));
  }
}
