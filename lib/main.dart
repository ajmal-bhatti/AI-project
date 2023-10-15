import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project/route.dart';
import 'package:project/voice2.dart';
import 'package:project/graph.dart';
import 'package:project/helpers.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'helpers.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

TextEditingController _sourceCantroller = TextEditingController();
TextEditingController _destinationController = TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late DirectedWeightedGraph uetGraph;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    loadParkGraph();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            Text(
              'Blind Navigation System',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Image.asset(
              'images/logo.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 50),
            SizedBox(height: 15, width: 450),
            Center(
              child: Container(
                  width: 350,
                  child: Column(
                    children: [
                      Source(controller: _sourceCantroller),
                      SizedBox(height: 20),
                      Destination(controller: _destinationController),
                    ],
                  )),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyRoute(
                              source: _sourceCantroller.text,
                              destination: _destinationController.text,
                            )),
                  );
                },
                child: Text("Start")),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: VoiceInputWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loadParkGraph() {
    widget.uetGraph = DirectedWeightedGraph();
    widget.uetGraph.addVertex("Entrance");
    widget.uetGraph.addVertex("Fountain Plaza");
    widget.uetGraph.addVertex("Rose Garden");
    widget.uetGraph.addVertex("Playground");
    widget.uetGraph.addVertex("Picnic Area");
    widget.uetGraph.addVertex("Botanical Gardens");
    widget.uetGraph.addVertex("Lake View Point");
    widget.uetGraph.addVertex("Bird Aviary");
    widget.uetGraph.addVertex("Sculpture Garden");
    widget.uetGraph.addVertex("Amphitheater");
    widget.uetGraph.addVertex("Cafeteria");
    widget.uetGraph.addVertex("Walking Trail");
    widget.uetGraph.addVertex("Sports Fields");
    widget.uetGraph.addVertex("Viewing Tower");
    widget.uetGraph.addVertex("Petting Zoo");

    widget.uetGraph.addEdge("Entrance", "Fountain Plaza", 5, "north");
    widget.uetGraph.addEdge("Fountain Plaza", "Rose Garden", 8, "east");
    widget.uetGraph.addEdge("Rose Garden", "Playground", 6, "southeast");
    widget.uetGraph.addEdge("Playground", "Picnic Area", 3, "south");
    widget.uetGraph
        .addEdge("Picnic Area", "Botanical Gardens", 10, "southwest");
    widget.uetGraph.addEdge("Botanical Gardens", "Lake View Point", 7, "west");
    widget.uetGraph.addEdge("Lake View Point", "Bird Aviary", 4, "northwest");
    widget.uetGraph.addEdge("Bird Aviary", "Sculpture Garden", 5, "north");
    widget.uetGraph.addEdge("Sculpture Garden", "Amphitheater", 9, "northeast");
    widget.uetGraph.addEdge("Amphitheater", "Cafeteria", 8, "east");
    widget.uetGraph.addEdge("Cafeteria", "Walking Trail", 4, "southeast");
    widget.uetGraph.addEdge("Walking Trail", "Sports Fields", 6, "south");
    widget.uetGraph.addEdge("Sports Fields", "Viewing Tower", 7, "southwest");
    widget.uetGraph.addEdge("Viewing Tower", "Petting Zoo", 5, "west");
    widget.uetGraph.addEdge("Petting Zoo", "Entrance", 12, "northwest");
  }

  void speakRoute({required String source, required String destination}) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
    await flutterTts.setPitch(2.0);
    await flutterTts
        .speak("You are at " + source + " and going to " + destination);
  }
}

class Source extends StatelessWidget {
  final TextEditingController controller;

  Source({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter your Location',
        labelText: 'Source',
        prefixIcon: Icon(Icons.location_city),
        suffixIcon: Icon(Icons.mic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class Destination extends StatelessWidget {
  final TextEditingController controller;

  Destination({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter your Destination',
        labelText: 'Destination',
        suffixIcon: Icon(Icons.mic),
        prefixIcon: Icon(Icons.map_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class VoiceInputWidget extends StatefulWidget {
  late DirectedWeightedGraph uetGraph;

  @override
  _VoiceInputWidgetState createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  bool isListening = false;
  final SpeechToText _speechToText = SpeechToText();
  String source = "";
  String destination = "";
  FlutterTts flutterTts = FlutterTts();
  int clickCount = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeakResult);
    setState(() {
      isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });

    if (widget.uetGraph.vertexExists(source.toLowerCase())) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceInput2Widget(source: source),
        ),
      );
    }
  }

  void _onSpeakResult(result) {
    setState(() {
      if (clickCount % 2 != 0) {
        source = result.recognizedWords ?? "";
        send_source(source);
      } else if (clickCount % 2 == 0) {
        destination = result.recognizedWords ?? "";
        send_destination(destination);
      }
    });
  }

  void speakRoute(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(2.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isListening ? 'Listening...' : 'Hold and Speak',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onLongPress: () async {
            setState(() {
              clickCount = clickCount + 1;
            });
            if (clickCount % 2 != 0) {
              speakRoute('Tell me where you are?');
              setState(() {
                isListening = true;
              });
            } else if (clickCount % 2 == 0) {
              speakRoute('Tell me your destination');
            }
            await Future.delayed(Duration(seconds: 1));
            _startListening();
          },
          onLongPressEnd: (LongPressEndDetails details) {
            setState(() {
              isListening = false;
            });
            _stopListening();
            print(source + "source");
            print(destination + "destination");
          },
          child: InkResponse(
            onTap: () {},
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              transform: Matrix4.identity()..scale(isListening ? 1.2 : 1.0),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Color.fromARGB(255, 0, 0, 0),
                size: isListening ? 35 : 35,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(source),
      ],
    );
  }

  void send_source(String source) {
    source = convertToLowercase(source);
    _sourceCantroller.text = "";
    _sourceCantroller.text = source;
    print(_sourceCantroller.text);
    print('///////////////////////////');
    print(source);
  }

  void send_destination(String destination) {
    destination = convertToLowercase(destination);
    _destinationController.text = "";
    _destinationController.text = destination;
    print(_sourceCantroller.text);
    print('///////////////////////////');
    print(destination);
  }

  String convertToLowercase(String input) {
    return input.toLowerCase();
  }
}
