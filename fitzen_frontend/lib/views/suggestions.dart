import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/constants.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  ScrollController scrollController = ScrollController();
  Player player = Player(id: 69420);
  //create a playlist with videos
  final playlist = Playlist(
    medias: [
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/intro.mp4?alt=media&token=7b39e9eb-2971-4578-9824-f6173a7ac229'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R1_ex1.mp4?alt=media&token=abcae931-ddfb-45b7-a9b7-0cbd59fb4b7a'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R1_ex2.mp4?alt=media&token=8a18d84e-64dc-46be-90c7-621115177113'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R1_ex3.mp4?alt=media&token=2c713e4c-0359-4f04-aad3-89d1091ef2f0'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R1_ex4.mp4?alt=media&token=0f84d273-d2b1-434c-8d18-c64593686b96'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R2_ex1.mp4?alt=media&token=5b8824ac-905f-4554-bc8f-117fbdff8049'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R2_ex2.mp4?alt=media&token=b1ec1293-c83f-44f1-9e91-5a2372835fe2'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R2_ex3.mp4?alt=media&token=b6ca76a7-2c29-4988-9fc5-908f1a672ae4'),
      Media.network('https://firebasestorage.googleapis.com/v0/b/flash-chat-64d66.appspot.com/o/R2_ex4.mp4?alt=media&token=7abcda92-7cb3-4d73-b975-f299456d0038'),
    ],
  );

  // Routine 1 Exercise names list
  final List<String> videoNames1 = [
    'Introduction',
    'Exercise 1: Over-And-Backs (10-15 slow reps)',
    'Exercise 2: Cobra Pose (5-10 slow reps with pause at top)',
    'Exercise 3: Stand and Reach (5-10 reaches each side, pause at the end position)',
    'Exercise 4: Wall slides with chin nod (2 sets of 10-15 reps)',
  ];

  // Routine 2 Exercise names list
  final List<String> videoNames2 = [
    'Exercise 1: Quadruped Thoracic Rotations (10 reps each side with pause at top)',
    'Exercise 2: Kneeling Hip Flexor Stretch (30-45 seconds holds each side)',
    'Exercise 3: Pigeon Stretch (30-45 second holds each side)',
    'Exercise 4: Glute Bridges (2 sets of 10-15 reps with pause at top position)',
  ];

  @override
  void initState() {
    super.initState();
    player.open(
      playlist,
      autoStart: true,
    );
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //app bar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButton(),
                    SizedBox(width: 20),
                    Icon(
                      Icons.tips_and_updates,
                      color: kBlue,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Suggestions",
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 30,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Video(
                    player: player,
                    height: 500,
                    progressBarActiveColor: kBlue,
                    volumeActiveColor: kBlue,
                    progressBarThumbColor: kBlue,
                    volumeThumbColor: kBlue,
                  ),
                ),
                SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    scrollController.animateTo(
                      500,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  icon: Icon(Icons.arrow_downward),
                ),

                Text(
                  // first routine heading
                  'Routine 1',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  itemCount: videoNames1.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        player.stop();
                        player.jumpToIndex(index);
                        scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          videoNames1[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // ---------------------------------------
                Text(
                  // second routine heading
                  'Routine 2',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  itemCount: videoNames2.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        player.stop();
                        player.jumpToIndex(index + 5);
                        scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          videoNames2[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
