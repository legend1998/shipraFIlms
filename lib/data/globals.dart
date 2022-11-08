import 'package:audio_service/audio_service.dart';

class MyGlobals {
  static final MyGlobals _instance = MyGlobals._internal();
  factory MyGlobals() => _instance;

  MyGlobals._internal() {
    _audioHandler = null;
  }

  AudioHandler? _audioHandler;

  AudioHandler get getAudioHandler => _audioHandler!;

  set setAudioHandler(AudioHandler handler) {
    _audioHandler = handler;
  }
}
