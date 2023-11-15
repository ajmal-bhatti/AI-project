import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project/voice2.dart';
import 'package:project/main.dart';
import 'package:project/graph.dart';
import 'package:project/helpers.dart';

class MyRoute extends StatefulWidget {
  late String source;
  late String destination;
  late DirectedWeightedGraph uetGraph;
  var path;
  late int steps;
  late int i;
  MyRoute({super.key, required this.destination, required this.source});

  @override
  State<MyRoute> createState() => _RouteState();
}

class _RouteState extends State<MyRoute> {
  FlutterTts flutterTts = FlutterTts();

  void speakRoute({required String source}) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
    await flutterTts.setPitch(2.0);
    await flutterTts.speak(source);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadParkGraph();
    print("azan");
    widget.path = widget.uetGraph.ucs(widget.source, widget.destination);
    print(widget.path);
    widget.i = 0;
    widget.steps = widget.path[widget.i]["weight"];
    speakRoute(
        source: "Go " +
            widget.steps.toString() +
            " steps " +
            widget.path[widget.i]["direction"] +
            " towards " +
            widget.path[widget.i]["to"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 8.0,
                  ),
                  color: Colors.grey[300],
                ),
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    widget.steps.toString(),
                    style: TextStyle(
                      fontSize: 100.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (widget.i == widget.path.length) {
                    speakRoute(source: "You Have reached your destination");
                    Navigator.pop(context);
                  } else if (widget.steps == 0) {
                    setState(() {
                      widget.i = widget.i + 1;
                      print("Azan" + widget.i.toString());
                      widget.steps = widget.path[widget.i]["weight"];
                      speakRoute(
                        source: "Go " +
                            widget.steps.toString() +
                            " steps " +
                            widget.path[widget.i]["direction"] +
                            " towards " +
                            widget.path[widget.i]["to"],
                      );
                    });
                  } else {
                    setState(() {
                      widget.steps = widget.steps - 1;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  padding: EdgeInsets.all(24.0),
                ),
                child: Text(
                  "Steps",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
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
}
