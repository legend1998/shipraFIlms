// ignore_for_file: file_names
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations
  final player = AudioPlayer();
  final _playlist =
      ConcatenatingAudioSource(children: [], useLazyPreparation: true);

  Future<void> _loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      repeatMode: const {
        LoopMode.off: AudioServiceRepeatMode.none,
        LoopMode.one: AudioServiceRepeatMode.one,
        LoopMode.all: AudioServiceRepeatMode.all,
      }[player.loopMode]!,
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      shuffleMode: player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      queueIndex: event.currentIndex,
    );
  }
  // The most common callbacks:

  MyAudioHandler() {
    _loadEmptyPlaylist();
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    player.sequenceStateStream.listen((event) {
      if (event?.currentSource != null) {
        MediaItem item = event?.currentSource?.tag;
        mediaItem.add(item);
      }
    });
  }

  @override
  Future<void> play() async {
    await player.play();
  }

  @override
  Future<void> pause() async {
    await player.pause();
  }

  @override
  Future<void> stop() async {
    await player.stop();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await player.setLoopMode(LoopMode.all);
        break;
    }
    return super.setRepeatMode(repeatMode);
  }

  @override
  Future<void> seek(Duration position) async {
    player.seek(position);
  }

  @override
  Future<void> skipToQueueItem(int i) async {}

  @override
  Future<void> prepareFromUri(Uri uri, [Map<String, dynamic>? extras]) {
    player.setUrl(uri.toString());
    mediaItem.add(MediaItem(
        id: uri.toString(),
        title: extras?["title"],
        duration: extras?["duration"],
        artUri: Uri.parse(extras?["icon"]),
        artist: extras?["artist"]));
    return super.prepareFromUri(uri, extras);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.id),
      tag: mediaItem,
    );
  }

  @override
  Future<void> skipToNext() async {
    //  print(player.currentIndex);
    player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() => player.seekToPrevious();

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) {
    List<AudioSource> sources = mediaItems.map(_createAudioSource).toList();
    _playlist.addAll(sources);
    player.setAudioSource(_playlist);
    return super.addQueueItems(mediaItems);
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) {
    var aSource = _createAudioSource(mediaItem);
    _playlist.insert(index, aSource);
    player.setAudioSource(_playlist, initialIndex: 0);
    return super.insertQueueItem(index, mediaItem);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    //print(describeEnum(shuffleMode));
    if (shuffleMode == AudioServiceShuffleMode.all) {
      await player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      await player.setShuffleModeEnabled(false);
    }
    return super.setShuffleMode(shuffleMode);
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    player.setAudioSource(_playlist,
        initialIndex: queue.value.indexOf(mediaItem));
  }

  @override
  Future<void> setSpeed(double speed) {
    player.setSpeed(1.0);
    return super.setSpeed(speed);
  }
}
