import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'soundplayer_platform_interface.dart';

/// An implementation of [SoundplayerPlatform] that uses method channels.
class MethodChannelSoundplayer extends SoundplayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('soundplayer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> initPlayer({int numStreams = 2}) {
    return methodChannel.invokeMethod("initSoundplayer", {"numStreams": numStreams});

  }

  Future<int> load({required String path}) async {
    int soundId = await methodChannel.invokeMethod("load", {"path": path});
    print(soundId);
    return soundId;
  }

  Future<void> unload({required int soundId}) async {
    await methodChannel.invokeMethod("unload", {"soundId": soundId});
  }

  Future<int> play({required int soundId}) async {
    int streamId = await methodChannel.invokeMethod("play", {"soundId": soundId});
    return streamId;
  }

  Future<void> pause({required int soundId}) async {
    await methodChannel.invokeMethod("pause", {"soundId": soundId});
  }

  Future<void> stop({required int streamId}) async {
    await methodChannel.invokeMethod("stop", {"streamId", streamId});
  }

  Future<void> release() async {
    await methodChannel.invokeMethod("release");
  }

}
