import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: VideoPlayerPage(),
    ));
  }
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  final List<String> _videoLinks1 = [
    'intro.mp4',
    'R1_ex1.mp4',
    'R1_ex2.mp4',
    'R1_ex3.mp4',
    'R1_ex4.mp4',
  ];
  final List<String> _videoNames1 = [
    'introduction',
    'Exercise 1: Over-And-Backs (10-15 slow reps)',
    'Exercise 2: Cobra Pose (5-10 slow reps with pause at top)',
    'Exercise 3: Stand and Reach (5-10 reaches each side, pause at the end position)',
    'Exercise 4: Wall slides with chin nod (2 sets of 10-15 reps)',
  ];
  final List<String> _videoLinks2 = [
    'R2_ex1.mp4',
    'R2_ex2.mp4',
    'R2_ex3.mp4',
    'R2_ex4.mp4',
  ];
  final List<String> _videoNames2 = [
    'Exercise 1: Quadruped Thoracic Rotations (10 reps each side with pause at top)',
    'Exercise 2: Kneeling Hip Flexor Stretch (30-45 seconds holds each side)',
    'Exercise 3: Pigeon Stretch (30-45 second holds each side)',
    'Exercise 4: Glute Bridges (2 sets of 10-15 reps with pause at top position)',
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/${_videoLinks1[0]}')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height:
              400, // wrapped the aspect ratio in a sized box to set the height of the video
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ----------------------------------
        // Column(
        // adding the routine 1 text above second link list by wrapping the ListView.builder with column and adding text above it.
        // children: [
        const Text(
          'Routine 1',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _videoLinks1.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _controller.pause();
                  _controller = VideoPlayerController.asset(
                      'assets/videos/${_videoLinks1[index]}')
                    ..initialize().then((_) {
                      setState(() {});
                      _controller.play();
                    });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    _videoNames1[index],
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
        // ----------------------------------------
        // Column(
        // adding the routine 1 text above second link list by wrapping the ListView.builder with column and adding text above it.
        // children: [
        const Text(
          'Routine 2',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _videoLinks2.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _controller.pause();
                  _controller = VideoPlayerController.asset(
                      'assets/videos/${_videoLinks2[index]}')
                    ..initialize().then((_) {
                      setState(() {});
                      _controller.play();
                    });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    _videoNames2[index],
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


// -------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//         home: Scaffold(
//       body: VideoPlayerPage(),
//     ));
//   }
// }

// class VideoPlayerPage extends StatefulWidget {
//   const VideoPlayerPage({super.key});

//   @override
//   _VideoPlayerPageState createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   late VideoPlayerController _controller;
//   final List<String> _videoLinks = [
//     'intro.mp4',
//     'R1_ex1.mp4',
//     'R1_ex2.mp4',
//     'R1_ex3.mp4',
//     'R1_ex4.mp4',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/videos/${_videoLinks[0]}')
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         AspectRatio(
//           aspectRatio: 16 / 9,
//           child: VideoPlayer(_controller),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           'Routine 1',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _videoLinks.length,
//             itemBuilder: (BuildContext context, int index) {
//               return InkWell(
//                 onTap: () {
//                   _controller.pause();
//                   _controller = VideoPlayerController.asset(
//                       'assets/videos/${_videoLinks[index]}')
//                     ..initialize().then((_) {
//                       setState(() {});
//                       _controller.play();
//                     });
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Routine 1'
//                     'Video ${index + 1}\n',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }


// ---------------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   late VideoPlayerController controller;

//   @override
//   void initState() {
//     loadVideoPlayer();
//     super.initState();
//   }

//   loadVideoPlayer() {
//     controller = VideoPlayerController.asset('assets/videos/intro.mp4');
//     controller.addListener(() {
//       setState(() {});
//     });
//     controller.initialize().then((value) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Play Video from Assets/URL"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(children: [
//         AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: VideoPlayer(controller),
//         ),
//         Text("Total Duration: ${controller.value.duration}"),
//         VideoProgressIndicator(controller,
//             allowScrubbing: true,
//             colors: const VideoProgressColors(
//               backgroundColor: Colors.redAccent,
//               playedColor: Colors.green,
//               bufferedColor: Colors.purple,
//             )),
//         Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   if (controller.value.isPlaying) {
//                     controller.pause();
//                   } else {
//                     controller.play();
//                   }

//                   setState(() {});
//                 },
//                 icon: Icon(controller.value.isPlaying
//                     ? Icons.pause
//                     : Icons.play_arrow)),
//           ],
//         )
//       ]),
//     );
//   }
// }
//---------------------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }
// // to run enter flutter

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Recommended exercises!'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Text(
//               'Routine 1 (Upper body Focus)\n',
//             ),
//           ],
//         ),
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
