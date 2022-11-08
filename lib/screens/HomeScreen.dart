// ignore_for_file: file_names

import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiprafilms/data/Song.dart';
import 'package:shiprafilms/data/Video.dart';
import 'package:shiprafilms/main.dart';
import 'package:shiprafilms/screens/SongPlayScreen.dart';
import 'package:shiprafilms/utils/CustomSearch.dart';
import 'package:shiprafilms/utils/cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> songs = [];
  List<Video> videos = [];
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  List<Widget> imageSliders() => imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                item,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          ))
      .toList();

  void getMusic() async {
    List<Song> tempSongs = await FirebaseFirestore.instance
        .collection("music")
        .get()
        .then(
            (value) => value.docs.map((e) => Song.fromJson(e.data())).toList());

    setState(() {
      songs = tempSongs;
    });
  }

  void callbackMusic(song) {
    if (currentMusic == song.url) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SongPlayScreen(song: song)));
      return;
    }
    MediaItem item = MediaItem(
        id: song.url!,
        title: song.title!,
        duration: Duration(milliseconds: song.duration!),
        artUri: Uri.parse(song.icon!),
        artist: song.artist!);

    if (audioHandler.queue.value.contains(item)) {
      currentMusic = song.url!;
      audioHandler.playMediaItem(item);
    } else {
      currentMusic = song.url!;
      audioHandler.insertQueueItem(0, item);
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SongPlayScreen(song: song)));
  }

  void getVideo() async {
    List<Video> tempSongs = await FirebaseFirestore.instance
        .collection("videos")
        .get()
        .then((value) =>
            value.docs.map((e) => Video.fromJson(e.data())).toList());

    setState(() {
      videos = tempSongs;
    });
  }

  @override
  void initState() {
    super.initState();
    getMusic();
    getVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          showSearch(
                              context: context, delegate: CustomSearch());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1, color: const Color(0xff09C1DE))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "type to search",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 5 / 2,
                        enlargeCenterPage: true,
                      ),
                      items: imageSliders(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Latest Music",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: songs
                              .map((e) => musicCard(callbackMusic, e))
                              .toList()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Recently Played ",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: songs
                              .map((e) => musicCard(callbackMusic, e))
                              .toList()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Latest Videos",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          videos.map((e) => videoCard(context, e)).toList(),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ]),
            )));
  }
}
