import 'package:flutter_test/flutter_test.dart';
import 'package:soundplayer/soundplayer.dart';
import 'package:soundplayer/soundplayer_platform_interface.dart';
import 'package:soundplayer/soundplayer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSoundplayerPlatform
    with MockPlatformInterfaceMixin
    implements SoundplayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SoundplayerPlatform initialPlatform = SoundplayerPlatform.instance;

  test('$MethodChannelSoundplayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSoundplayer>());
  });

  test('getPlatformVersion', () async {
    Soundplayer soundplayerPlugin = Soundplayer(1, 1.0);
    MockSoundplayerPlatform fakePlatform = MockSoundplayerPlatform();
    SoundplayerPlatform.instance = fakePlatform;

    expect(await soundplayerPlugin.getPlatformVersion(), '42');
  });
}
