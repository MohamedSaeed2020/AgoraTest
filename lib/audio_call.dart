import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_test/app_brain.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  //initialize the engine and the remote user id
  int _remoteUid = 0;
  late RtcEngine _engine;

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
          Container(
            color: Colors.black87,
            child: Center(
              child: _remoteUid == 0
                  ? const Text(
                      'Calling…',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Calling with $_remoteUid',
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 25),
              child: Container(
                height: 50,
                color: Colors.black12,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: const Icon(
                      Icons.call_end,
                      size: 44,
                      color: Colors.redAccent,
                    )),
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
        },
        userJoined: (int uid, int elapsed) {
          log('remote user $uid joined successfully');
          setState(() => _remoteUid = uid);
        },
        userOffline: (int uid, UserOfflineReason reason) {
          log('remote user $uid left call');
          setState(() => _remoteUid = 0);
          Navigator.of(context).pop(true);
        },
      ),
    );
    await _engine.joinChannel(
        AgoraManager.token, AgoraManager.channelName, null, 0);
  }

  Widget _renderRemoteAudio() {
    if (_remoteUid != 0) {
      return Text(
        'Calling with $_remoteUid',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return const Text(
        'Calling …',
        style: TextStyle(color: Colors.white),
      );
    }
  }
}
