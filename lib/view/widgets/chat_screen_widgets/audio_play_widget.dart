import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:store_user/utils/constants.dart';

class AudioPlay extends StatefulWidget {
  String message;
  bool isMe;

  @override
  State<AudioPlay> createState() => _AudioPlayState();

  AudioPlay({
    required this.message,
    required this.isMe,
  });
}

class _AudioPlayState extends State<AudioPlay> {
  final player = AudioPlayer();
  Duration? duration;
  String? url;

  @override
  void initState() {
    super.initState();
    // player.setUrl(widget.message).then((value) {
    //   setState(() {
    //     duration = value;
    //   });
    // });

    setState(() {
      url = widget.message;
      print(url);
    });
    player.setUrl(url!).asStream().listen((event) {
      setState(() {
        duration = event;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .7,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //SizedBox(width: Get.width * 0.4),
          Expanded(
            child: Container(
              height: Get.height * .06,
              padding: const EdgeInsets.only(left: 12, right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Get.width * .05),
                color: widget.isMe ? mainColor2 : mainColor4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (context, snapshot) {
                          try {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return GestureDetector(
                                child: SizedBox(
                                  height: Get.width * .07,
                                  width: Get.width * .07,
                                  child: const CircularProgressIndicator(
                                    color: white,strokeWidth: 2,
                                  ),
                                ),
                                onTap: player.play,
                              );
                            } else if (playing != true) {
                              return GestureDetector(
                                child: const Icon(Icons.play_arrow,
                                    color: Colors.white),
                                onTap: player.play,
                              );
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return GestureDetector(
                                child: const Icon(Icons.pause,
                                    color: Colors.white),
                                onTap: player.pause,
                              );
                            } else {
                              return GestureDetector(
                                child: const Icon(Icons.replay,
                                    color: Colors.white),
                                onTap: () {
                                  player.seek(Duration.zero);
                                },
                              );
                            }
                          } catch (e) {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            try {
                              if (snapshot.hasData) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 13),
                                    LinearProgressIndicator(
                                      value: snapshot.data!.inMilliseconds /
                                          (duration?.inMilliseconds ?? 1),
                                      color: Color(0xff5EE6EB),
                                      backgroundColor: Color(0xFFF5F5F5),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          prettyDuration(
                                              snapshot.data! == Duration.zero
                                                  ? duration ?? Duration.zero
                                                  : snapshot.data!),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // const Text(
                                        //   "M4A",
                                        //   style: TextStyle(
                                        //     fontSize: 10,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return const LinearProgressIndicator();
                              }
                            } catch (e) {
                              return const LinearProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}
