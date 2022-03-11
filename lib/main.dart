import 'package:flutter/material.dart';
import 'package:voice_recorder/api/sound_player.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
import 'package:voice_recorder/widget.dart/timer_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final recorder = SoundRecorder();
  final timerController = TimerController();
  final player = SoundPlayer();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = player.isPlaying;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimerWidget(controller: timerController),
            buildStart(),
            TextButton(
                onPressed: () async {
                  await player.togglePlaying(
                      whenFinished: () => setState(() {
                            timerController.stopTimer();
                          }));
                  if (!isPlaying) {
                    timerController.startTimer();
                  } else {
                    timerController.stopTimer();
                  }
                  setState(() {});
                },
                child: Text(isPlaying ? "STOP" : "PLAY"))
          ],
        ),
      ),
    );
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";

    return ElevatedButton.icon(
        onPressed: () async {
          await recorder.toggleRecording();
          final isRecording = await recorder.isRecording;
          setState(() {});
          if (isRecording) {
            timerController.startTimer();
          } else {
            timerController.stopTimer();
          }
        },
        icon: Icon(icon),
        label: Text(text));
  }
}
