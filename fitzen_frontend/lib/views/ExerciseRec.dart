import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // late VideoPlayerController controller;
  bool isPlaying = true;

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
    // controller = VideoPlayerController.asset(
    //     'assets/videos/${videoLinks1[0]}') // accessing the videos from the video lists
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 400, // wrapped the aspect ratio in a sized box to set the height of the video
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                // adding the playpause button
                alignment: Alignment.bottomCenter,
                children: [
                  // VideoPlayer(controller),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPlaying) {
                          // controller.pause();
                        } else {
                          // controller.play();
                        }
                        isPlaying = !isPlaying;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // adding a small gap between the 2 routines with a empty SizedBox

        // ----------------------------------
        const Text(
          // first routine heading
          'Routine 1',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          // looping through the link list 1 and accessing the videos after clicked
          child: ListView.builder(
            itemCount: videoLinks1.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  // controller.pause();
                  // controller = VideoPlayerController.asset('assets/videos/${videoLinks1[index]}')
                  //   ..initialize().then((_) {
                  //     setState(() {});
                  //     controller.play();
                  //   });
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
        ),
        //   ],
        // ),
        const SizedBox(height: 20),
        // ---------------------------------------
        const Text(
          // second routine heading
          'Routine 2',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          // looping through the link list 2 and accessing the videos after clicked
          child: ListView.builder(
            itemCount: videoLinks2.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  // controller.pause();
                  // controller = VideoPlayerController.asset('assets/videos/${videoLinks2[index]}')
                  //   ..initialize().then((_) {
                  //     setState(() {});
                  //     controller.play();
                  //   });
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
        ),
        //   ],
        // ),
      ],
    );
  }
}
