import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_user/view/widgets/utils_widgets/image_viewer.dart';

import '../../../utils/constants.dart';

import 'package:just_audio/just_audio.dart';

class ChatBuble extends StatefulWidget {
  ChatBuble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isAudio,
    required this.isImage,
    required this.isVideo,
    //  required this.messageId,
  }) : super(key: key);
  final message;
  bool isMe;
  bool isAudio;
  bool isImage;
  bool isVideo;

  // String messageId;

  @override
  State<ChatBuble> createState() => _ChatBubleState();
}

class _ChatBubleState extends State<ChatBuble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    widget.isAudio
        ? player.setUrl(widget.message).then((value) {
            setState(() {
              duration = value;
            });
          })
        : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: widget.isMe
              ? BorderRadius.only(
                  topRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17),
                  topLeft: Radius.circular(17))
              : BorderRadius.only(
                  topRight: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                  topLeft: Radius.circular(17)),
          color: widget.isMe ? mainColor2 : mainColor4,
        ),
        child: widget.isImage
            ? InkWell(
                onTap: () {
                  Get.to(
                      () => ImageViewer(
                            imageUrl: widget.message,
                          ),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 200));
                },
                child: SizedBox(
                    height: Get.width * .6,
                    width: Get.width * .7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/l.gif",
                          image: widget.message),
                    )),
              )
            : widget.isVideo
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: BetterPlayer.network(
                      widget.message,
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                          showPlaceholderUntilPlay: true,
                          fit: BoxFit.contain,
                          autoDetectFullscreenAspectRatio: true,
                          autoDetectFullscreenDeviceOrientation: true,
                          expandToFill: false,
                          fullScreenByDefault: false),
                    ),
                  )
                : widget.isAudio
                    ? Container(
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
                                padding:
                                    const EdgeInsets.only(left: 12, right: 18),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Get.width * .05),
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
                                              final playing =
                                                  playerState?.playing;
                                              if (processingState ==
                                                      ProcessingState.loading ||
                                                  processingState ==
                                                      ProcessingState
                                                          .buffering) {
                                                return GestureDetector(
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: player.play,
                                                );
                                              } else if (playing != true) {
                                                return GestureDetector(
                                                  child: const Icon(
                                                      Icons.play_arrow,
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
                                                  child: const Icon(
                                                      Icons.replay,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const SizedBox(
                                                          height: 13),
                                                      LinearProgressIndicator(
                                                        value: snapshot.data!
                                                                .inMilliseconds /
                                                            (duration
                                                                    ?.inMilliseconds ??
                                                                1),
                                                        color:
                                                            Color(0xff5EE6EB),
                                                        backgroundColor:
                                                            Color(0xFFF5F5F5),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            prettyDuration(snapshot
                                                                        .data! ==
                                                                    Duration
                                                                        .zero
                                                                ? duration ??
                                                                    Duration
                                                                        .zero
                                                                : snapshot
                                                                    .data!),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
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
                      )
                    // : isAudio
                    //     ? SizedBox(
                    //         width: Get.width * .7,
                    //         height: Get.height * .05,
                    //         child: Row(
                    //           children: [
                    //             Card(
                    //               shadowColor: white,
                    //               elevation: 1,
                    //               margin: EdgeInsets.all(1),
                    //               color: white,
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(16)),
                    //               child: IconButton(
                    //                 padding: EdgeInsets.zero,
                    //                 onPressed: getPlaybackFn(),
                    //                 icon: Icon(_mPlayer!.isPlaying
                    //                     ? Icons.pause_circle_outline
                    //                     : IconBroken.Play),
                    //               ),
                    //             ),
                    //             Expanded(
                    //                 child: Padding(
                    //               padding: EdgeInsets.all(8),
                    //               child: SliderTheme(
                    //                 data: SliderTheme.of(context).copyWith(
                    //                   activeTrackColor: mainColor,
                    //                   inactiveTrackColor: Colors.grey,
                    //                   thumbShape: RoundSliderThumbShape(
                    //                       enabledThumbRadius: 7.0),
                    //                   overlayShape: RoundSliderOverlayShape(
                    //                       overlayRadius: 12.0),
                    //                 ),
                    //                 child: Slider(
                    //                   min: 0,
                    //                   max: 500,
                    //                   // max: messagesController
                    //                   //     .duration.inSeconds
                    //                   //     .toDouble(),
                    //                   // value: messagesController
                    //                   //     .position.inSeconds
                    //                   //     .toDouble(),
                    //                   onChanged: (value) async {
                    //                     await seekToPlayer(value.toInt());
                    //                   },
                    //                   value: min(sliderCurrentPosition, maxDuration),
                    //                 ),
                    //               ),
                    //             )),
                    //             KTextUtils(
                    //               text: _playerTxt,
                    //               // text: "$twoDigitMinutes:$twoDigitSeconds",
                    //                 size: 15,
                    //                 color: white,
                    //                 fontWeight: FontWeight.w700,
                    //                 textDecoration: TextDecoration.none)
                    //           ],
                    //         ),
                    //       )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${widget.message}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
      ),
    );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return min + ":" + sec;
  }
}
