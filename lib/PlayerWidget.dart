import 'dart:async';

import 'package:dyeus_player/SongDetails.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;

  PlayerWidget({this.url, this.mode = PlayerMode.MEDIA_PLAYER});

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText =>
      _duration?.toString()?.substring(2)?.split('.')?.first ?? '--:--';

  get _positionText =>
      _position?.toString()?.substring(2)?.split('.')?.first ?? '--:--';

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SongDetails(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              MdiIcons.skipPreviousCircle,
              size: 48.0,
              color: Color(0xFF5C5C6E),
            ),
            IconButton(
              onPressed: () {
                if (_isPlaying) {
                  _pause();
                } else {
                  _play();
                }
                return;
              },
              iconSize: 80.0,
              icon: _isPlaying
                  ? Icon(MdiIcons.pauseCircle)
                  : Icon(MdiIcons.playCircle),
              color: Color(0xFF5C5C6E),
            ),
            Icon(
              MdiIcons.skipNextCircle,
              size: 48.0,
              color: Color(0xFF5C5C6E),
            )
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              child: Slider(
                activeColor: Color(0xFF5C5C6E),
                inactiveColor: Color(0xFFA5A7B0),
                onChanged: (v) {
                  final Position = v * _duration.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: Position.round()));
                },
                value: (_position != null &&
                        _duration != null &&
                        _position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_positionText ?? '--:--'),
                  Text(_durationText ?? '--:--',
                      style: TextStyle(
                          color: Color(0xFF5C5C6E),
                          fontFamily: 'DMSans-Regular')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
          title: 'App Name',
          artist: 'Artist or blank',
          albumTitle: 'Name or blank',
          imageUrl: 'url or blank',
          // forwardSkipInterval: const Duration(seconds: 30), // default is 30s
          // backwardSkipInterval: const Duration(seconds: 30), // default is 30s
          duration: duration,
          elapsedTime: Duration(seconds: 0),
          hasNextTrack: true,
          hasPreviousTrack: false,
        );
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.onPlayerCommand.listen((command) {
      print('command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, position: playPosition, isLocal: true);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
