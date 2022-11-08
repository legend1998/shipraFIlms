import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shiprafilms/firebase_options.dart';
import 'package:shiprafilms/screens/MainNavigation.dart';
import 'package:shiprafilms/service/AudioService.dart';

late AudioHandler audioHandler;
String currentMusic = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationOngoing: true,
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          bottomAppBarColor: const Color(0xff09C1DE),
          scaffoldBackgroundColor: const Color(0xff064954)),
      // routes: {
      //   '/': (ctx) => CarouselDemoHome(),
      //   '/basic': (ctx) => BasicDemo(),
      //   '/nocenter': (ctx) => NoCenterDemo(),
      //   '/image': (ctx) => ImageSliderDemo(),ubageDemo(),
      //   '/enlarge': (ctx) => EnlargeStrategyDemo(),
      //   '/manual': (ctx) => ManuallyControlledSlider(),
      //   '/noloop': (ctx) => NoonLoopingDemo(),
      //   '/vertical': (ctx) => VerticalSliderDemo(),
      //   '/fullscreen': (ctx) => FullscreenSliderDemo(),
      //   '/ondemand': (ctx) => OnDemandCarouselDemo(),
      //   '/indicator': (ctx) => CarouselWithIndicatorDemo(),
      //   '/prefetch': (ctx) => PrefetchImageDemo(),
      //   '/reason': (ctx) => CarouselChangeReasonDemo(),
      //   '/position': (ctx) => KeepPageviewPositionDemo(),
      //   '/multiple': (ctx) => MultipleItemDemo(),
      // },
      home: const MainNavigation(),
    );
  }
}
