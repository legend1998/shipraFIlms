// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shiprafilms/data/Song.dart';
import 'package:shiprafilms/data/Video.dart';
import 'package:shiprafilms/screens/VideoPlayScreen.dart';

Widget musicCard(callback, Song song) {
  return InkWell(
      onTap: () {
        callback(song);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            // gradient: const LinearGradient(
            //     colors: [Colors.black38, Colors.black87],
            //     begin: Alignment.bottomCenter,
            //     end: Alignment.topCenter),
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
                image: NetworkImage(
                  song.icon!,
                ),
                fit: BoxFit.fill)),
        width: 100,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            song.title!,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ));
}

Widget videoCard(context, Video video) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: Column(children: [
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayScreen(video: video)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(6)),
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage("images/loading.gif"),
              image: NetworkImage(video.icon as String)),
        ),
      ),
      Row(
        children: [
          Expanded(
              child: Text(
            video.title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
          )),
          const SizedBox(
            width: 50,
          ),
          Text(
            (video.duration! / 1000).toString(),
            style: const TextStyle(color: Colors.white),
          )
        ],
      )
    ]),
  );
}

Widget musicFolder() => Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(8)),
      child: const Center(
          child: Text(
        "Folder Name",
        style: TextStyle(color: Colors.white),
      )),
    );

Widget musicRecomended() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    height: 120,
    decoration: BoxDecoration(
        color: const Color(0x279E9C9C), borderRadius: BorderRadius.circular(5)),
    child: Row(children: [
      Container(
        margin: const EdgeInsets.only(left: 5),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.yellowAccent),
      ),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "this is the song currently have",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              "unknown artist",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            )),
      )
    ]),
  );
}
