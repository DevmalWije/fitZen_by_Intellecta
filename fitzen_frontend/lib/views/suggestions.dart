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
  Media network = Media.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
  final playlist = Playlist(
    medias: [
      Media.network('https://www.example.com/music.aac'),
    ],
  );

  // Routine 1 video list
  final List<String> videoLinks1 = [
    'intro.mp4',
    'R1_ex1.mp4',
    'R1_ex2.mp4',
    'R1_ex3.mp4',
    'R1_ex4.mp4',
  ];

  // Routine 1 Exercise names list
  final List<String> videoNames1 = [
    'introduction',
    'Exercise 1: Over-And-Backs (10-15 slow reps)',
    'Exercise 2: Cobra Pose (5-10 slow reps with pause at top)',
    'Exercise 3: Stand and Reach (5-10 reaches each side, pause at the end position)',
    'Exercise 4: Wall slides with chin nod (2 sets of 10-15 reps)',
  ];

  // Routine 2 video list
  final List<String> videoLinks2 = [
    'R2_ex1.mp4',
    'R2_ex2.mp4',
    'R2_ex3.mp4',
    'R2_ex4.mp4',
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
      network,
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
                  itemCount: videoLinks1.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
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
                  itemCount: videoLinks2.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
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
