import 'package:diabetes/pages/DiabetesYogaListPage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // For fullscreen mode
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class ExerciseDetailPage extends StatefulWidget {
  final YogaExercise exercise;

  ExerciseDetailPage({required this.exercise});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullscreen = false;
  bool _isTraining = false;
  DateTime? _trainingStartTime;
  Duration? _trainingDuration;
  double _caloriesBurned = 0.0;
  double _userWeight = 70.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.exercise.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _fetchUserWeight();
  }

  Future<void> _fetchUserWeight() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('user_id') // Replace with the authenticated user's ID
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          _userWeight = userDoc.data()!['weight'] ?? 70.0;
        });
      }
    } catch (e) {
      print('Error fetching weight: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Toggle fullscreen mode
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      // Set the app to fullscreen mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      // Reset back to normal
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  // Forward 10 seconds
  void _forwardVideo() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  // Rewind 10 seconds
  void _rewindVideo() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  // Toggle training mode (start/stop)
  void _toggleTraining() {
    setState(() {
      if (_isTraining) {
        // Stop training
        _trainingDuration = DateTime.now().difference(_trainingStartTime!);
        _isTraining = false;

        // Calculate burned calories
        final durationInHours = _trainingDuration!.inSeconds / 3600;
        final metValue = widget.exercise.met ?? 1.0; // MET value for yoga
        _caloriesBurned = metValue * _userWeight * durationInHours;

        // Show training duration
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Training Completed'),
              content: Text(
                  'You trained for ${_trainingDuration!.inMinutes} minutes and ${_trainingDuration!.inSeconds % 60} seconds.\nCalories Burned: ${_caloriesBurned.toStringAsFixed(2)} kcal.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Start training
        _trainingStartTime = DateTime.now();
        _isTraining = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isTraining) {
          final shouldFinish = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Finish Training?'),
                content: Text(
                    'You are currently in training mode. Do you want to finish training before exiting?'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // User chooses "No"
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      _toggleTraining(); // Stop training
                      Navigator.of(context)
                          .pop(true); // Close the dialog and indicate "Yes"

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Training Completed'),
                            content: Text(
                              'You trained for ${_trainingDuration!.inMinutes} minutes and ${_trainingDuration!.inSeconds % 60} seconds.\nCalories Burned: ${_caloriesBurned.toStringAsFixed(2)} kcal.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(), // Close duration dialog
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      Navigator.pop(context); // Navigate back
                      Navigator.pop(context); // Navigate back
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );

          return shouldFinish ??
              false; // Do nothing if "No" or dialog dismissed
        }

        return true; // Allow navigation if not in training mode
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.exercise.title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 2, 85, 152),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              if (_isTraining) {
                final shouldFinish = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Finish Training?'),
                      content: Text(
                          'You are currently in training mode. Do you want to finish training before exiting?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pop(false), // User chooses "No"
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            _toggleTraining(); // Stop training
                            Navigator.of(context)
                                .pop(true); // User chooses "Yes"

                            // Show training duration
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Training Completed'),
                                  content: Text(
                                    'You trained for ${_trainingDuration!.inMinutes} minutes and ${_trainingDuration!.inSeconds % 60} seconds.\nCalories Burned: ${_caloriesBurned.toStringAsFixed(2)} kcal.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                            Navigator.pop(context); // Navigate back
                            Navigator.pop(context);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldFinish != true)
                  return; // Do nothing if "No" or dialog dismissed
              } else {
                Navigator.pop(context); // Navigate back directly
              }
            },
          ),
        ),
        body: Container(
          color:
              const Color.fromARGB(255, 182, 206, 224), // Light blue background
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.exercise.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Center(
                    child: Text(
                      widget.exercise.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Video and Play/Pause Button inside a Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.blue[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Video Player
                        if (_controller.value.isInitialized)
                          Container(
                            height: 200,
                            child: VideoPlayer(_controller),
                          )
                        else
                          Center(child: CircularProgressIndicator()),

                        const SizedBox(height: 20),

                        // Controls (Forward, Play/Pause, Backward, Fullscreen)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Backward button on the left
                            IconButton(
                              icon: Icon(Icons.replay_10),
                              onPressed: _rewindVideo,
                              color: Colors.blue[800],
                              iconSize: 40,
                            ),

                            // Play/Pause button (centered)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),

                            // Forward button on the right
                            IconButton(
                              icon: Icon(Icons.forward_10),
                              onPressed: _forwardVideo,
                              color: Colors.blue[800],
                              iconSize: 40,
                            ),

                            // Fullscreen button aligned to the right
                            GestureDetector(
                              onTap: _toggleFullscreen,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isFullscreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Steps in One Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.blue[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Steps to Perform:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Numbered Steps with Bold Numbers
                        ...List.generate(
                          widget.exercise.steps.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5),
                                children: [
                                  TextSpan(
                                    text: "${index + 1}. ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800]),
                                  ),
                                  TextSpan(
                                    text: widget.exercise.steps[index],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: _isTraining ? Colors.red : Colors.green,
          onPressed: _toggleTraining,
          icon: Icon(
            _isTraining ? Icons.stop : Icons.play_arrow,
            color: Colors.white,
          ),
          label: Text(
            _isTraining ? 'Finish' : 'Start',
            style: TextStyle(color: Colors.white),
          ),
          tooltip: _isTraining ? 'Finish Training' : 'Start Training',
        ),
      ),
    );
  }
}
