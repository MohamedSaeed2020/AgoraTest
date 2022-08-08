import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:agora_test/app_brain.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  //initialize the engine and the remote user id
  int? _remoteUid;
  late RtcEngine _engine;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _renderRemoteVideo(),
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
              child: SizedBox(
                height: 150,
                width: 150,
                child: _renderLocalPreview(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 25),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.call_end,
                  size: 44,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(AgoraManager.appId);
    _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          log('local user $uid joined successfully');
          setState(() => _localUserJoined = true);
        },
        userJoined: (int uid, int elapsed) {
          log('remote user $uid joined successfully');
          setState(() => _remoteUid = uid);
        },
        userOffline: (int uid, UserOfflineReason reason) {
          log('remote user $uid left call');
          setState(() => _remoteUid = null);
          Navigator.of(context).pop(true);
        },
      ),
    );
    await _engine.joinChannel(
        AgoraManager.token, AgoraManager.channelName, null, 0);
  }

  //Display current User View
  Widget _renderLocalPreview() {
    if (_localUserJoined) {
      return const rtc_local_view.SurfaceView();
    } else {
      return const CircularProgressIndicator();
    }
  }

//Display remote User View
  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return rtc_remote_view.SurfaceView(
        channelId: AgoraManager.channelName,
        uid: _remoteUid!,
      );
    } else {
      return Center(
        child: Text(
          'Please wait for remote user to join',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
