# soundplayer

A low-latency soundplayer implemented using android's soundpool

## Features

 Dart interface to a wrapper of android soundpool.  
 Functions include: initSoundplayer, load, loadMultiple, play, playMultiple, unload, stop, pause

You must call initSoundplayer before doing anything else.  Once initialized the parameters and returns are the same as andriod's version.

To load a file simply add to your flutter assets and call load as you normally would with any other flutter file
    var soundId = _soundplayerPlugin.load("lib/assets/c4.wav");

Playing the Audio is achieved by 
    var streamId = _soundplayerPlugin.load(soundId);



