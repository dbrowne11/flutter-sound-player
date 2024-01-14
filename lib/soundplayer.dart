
import 'soundplayer_platform_interface.dart';
import 'soundplayer_method_channel.dart';

class Soundplayer {
  Future<String?> getPlatformVersion() {
    return SoundplayerPlatform.instance.getPlatformVersion();
  }

  int numStreams = 1;
  num volume = 1.0;
  var methodChannel = MethodChannelSoundplayer();

  Soundplayer(this.numStreams, this.volume, );

  Future<void> initSoundplayer(int numStreams) async {
    await methodChannel.initPlayer();
  }

  Future<int> load(String path) async {
    return await methodChannel.load(path:path);
  }

  Future<int> _loadNoWait(String path) async {
    return methodChannel.load(path: path);
  }
  
  Future<List<int>> loadMultiple(List<String> paths) async {
    List<Future<int>> futures = [];

    paths.forEach((element) {futures.add(_loadNoWait(element));});

    var result = Future.wait(futures);
    return result;
  }

  Future<int> play(int soundId) async {
    return methodChannel.play(soundId: soundId);
  }

  Future<List<int>> playMultiple(List<int> soundIds) {
    List<Future<int>> futures = [];

    soundIds.forEach((element) {futures.add(play(element));});
    return Future.wait(futures);
  }

  void unload(int soundId) {
    methodChannel.unload(soundId: soundId);
  }

  void pause(int soundId) {
    methodChannel.pause(soundId: soundId);

  }

  void stop(int streamId) {
    methodChannel.stop(streamId: streamId);
  }

}
