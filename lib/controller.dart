import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

typedef Fn = void Function();

class Control extends GetxController {
 // final player = FlutterSoundPlayer();

  Duration duration = new Duration();
  Duration position = new Duration();
  RxBool isPlaying = false.obs;
  Codec _codec = Codec.aacMP4;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  bool isPlayerReady=false;
  @override
  void initState() {
    super.onInit();

    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited = true;
      update();
    });
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer!.closePlayer();
    _mPlayer = null;

    super.dispose();
  }

  // -------  Here is the code to playback a remote file -----------------------
  Future initPlayer() async {

    await _mPlayer!.openPlayer();


    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    _mPlayer!.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
    isPlayerReady = true;
    update();
  }
  void play(url) async {
    await _mPlayer!.startPlayer(
        fromURI: url,
        codec: _codec,
        whenFinished: () {
          update();
        });
    update();
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer!.stopPlayer();
    }
  }

  // --------------------- UI -------------------

  getPlaybackFn(url) {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer!.isStopped
        ? play(url)
        : () {
            stopPlayer().then((value) => update());
          };
  }
}
