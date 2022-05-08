import 'dart:async';

import 'package:better_player/better_player.dart';
 import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
class EventListenerPage extends StatefulWidget {
  @override
  _EventListenerPageState createState() => _EventListenerPageState();
}

class _EventListenerPageState extends State<EventListenerPage> {
  late BetterPlayerController _betterPlayerController;
  List<BetterPlayerEvent> events = [];
  StreamController<DateTime> _eventStreamController =
  StreamController.broadcast();
  Duration? duration;
  @override
  void initState() {
    String rt="https://firebasestorage.googleapis.com/v0/b/user-17bfd.appspot.com/o/status%2Fimage_picker6177712424162244206.mp4?alt=media&token=03e628ca-1513-4609-aeac-11d68891dd7d";
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, "https://firebasestorage.googleapis.com/v0/b/user-17bfd.appspot.com/o/status%2Fimage_picker6177712424162244206.mp4?alt=media&token=03e628ca-1513-4609-aeac-11d68891dd7d");
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);    player.setUrl(rt).asStream().listen((event) {
      setState(() {
        duration = event;
        print("dddssssssssssssssssssssssssssssss"+ duration!.inSeconds.toString());
      });
    });
    _betterPlayerController.addEventsListener(_handleEvent);

    super.initState();
  }
  final player = AudioPlayer();
  @override
  void dispose() {
    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(BetterPlayerEvent event) {
    events.insert(0, event);

    ///Used to refresh only list of events
    _eventStreamController.add(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event listener"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Better Player exposes events which can be listened with event "
                  "listener. Start player to see events flowing.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: _eventStreamController.stream,
              builder: (context, snapshot) {
                return ListView(
                  children: events
                      .map(
                        (event) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Event: ${event.betterPlayerEventType} "
                            "parameters: ${(event.parameters ?? <String, dynamic>{}).toString()}"),
                        Divider(),
                      ],
                    ),
                  )
                      .toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}