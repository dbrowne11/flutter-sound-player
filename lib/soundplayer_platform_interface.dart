import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'soundplayer_method_channel.dart';

abstract class SoundplayerPlatform extends PlatformInterface {
  /// Constructs a SoundplayerPlatform.
  SoundplayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SoundplayerPlatform _instance = MethodChannelSoundplayer();

  /// The default instance of [SoundplayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSoundplayer].
  static SoundplayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SoundplayerPlatform] when
  /// they register themselves.
  static set instance(SoundplayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

}
