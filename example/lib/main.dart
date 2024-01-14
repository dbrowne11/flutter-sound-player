import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:soundplayer/soundplayer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _soundplayerPlugin = Soundplayer(2, 1.0);
  List<int> exerciseNotes = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _soundplayerPlugin.initSoundplayer(1);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _soundplayerPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            TextButton(onPressed: loadAndPlayTest2, child: Text("TestButton"))
          ],
        ),
      ),
    );
  }

  void loadAndPlayTest() {
    var soundId = _soundplayerPlugin.load("lib/assets/c4.wav");
    var soundId1 = _soundplayerPlugin.load("lib/assets/e4.wav");
    var soundId2 = _soundplayerPlugin.load("lib/assets/g4.wav");
    soundId.then(
        (value) => {soundId1.then(
            (value1) => { soundId2.then(
                (value2) =>
                {
                  _soundplayerPlugin.play(value2)
                }),

            _soundplayerPlugin.play(value1)
            }),

        _soundplayerPlugin.play(value)
    });

  }
  
  Future<void> loadNotes() async {
    var notes = ["lib/assets/c4.wav", "lib/assets/e4.wav", "lib/assets/g4.wav"];
    _soundplayerPlugin.loadMultiple(notes).then((value) => {exerciseNotes = value});
  }
  
  void playNotes() async {
    await _soundplayerPlugin.playMultiple(exerciseNotes);
  }

  void loadAndPlayTest2() async {
    await loadNotes();
    playNotes();
  }

}
