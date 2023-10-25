class WeightAndDirection {
  int weight;
  String direction;
  WeightAndDirection({required this.weight, required this.direction});
}

class DirectedWeightedGraph {
  Map<String, Map<String, WeightAndDirection>> _adjacencyList;

  DirectedWeightedGraph()
      : _adjacencyList = {}; // Initialize the field in the constructor

  void addVertex(String vertex) {
    if (!_adjacencyList.containsKey(vertex)) {
      _adjacencyList[vertex] = {};
    }
  }

  void addEdge(
      String startVertex, String endVertex, int weight, String direction) {
    if (!_adjacencyList.containsKey(startVertex)) {
      addVertex(startVertex);
    }
    if (!_adjacencyList.containsKey(endVertex)) {
      addVertex(endVertex);
    }

    _adjacencyList[startVertex]![endVertex] =
        WeightAndDirection(weight: weight, direction: direction);
  }

  bool vertexExists(String vertex) {
    return _adjacencyList.containsKey(vertex);
  }

  List<Map<String, dynamic>> ucs(String startVertex, String goalVertex) {
    List<Node> priorityQueue = [];
    Map<String, int> costSoFar = {startVertex: 0};
    Map<String, String> cameFrom = {};

    priorityQueue.add(Node(startVertex, 0));

    while (priorityQueue.isNotEmpty) {
      priorityQueue.sort((a, b) => a.cost.compareTo(b.cost));
      Node current = priorityQueue.removeAt(0);

      if (current.vertex == goalVertex) {
        return reconstructPath(cameFrom, startVertex, goalVertex);
      }

      _adjacencyList[current.vertex]!.forEach((neighbor, weightAndDirection) {
        int newCost = costSoFar[current.vertex]! + weightAndDirection.weight;

        if (!costSoFar.containsKey(neighbor) ||
            newCost < costSoFar[neighbor]!) {
          costSoFar[neighbor] = newCost;
          priorityQueue.add(Node(neighbor, newCost));
          cameFrom[neighbor] = current.vertex;
        }
      });
    }

    return []; // No path found
  }

  List<Map<String, dynamic>> reconstructPath(
      Map<String, String> cameFrom, String startVertex, String goalVertex) {
    List<Map<String, dynamic>> path = [];
    String current = goalVertex;

    while (current != startVertex) {
      String fromVertex = cameFrom[current]!;
      path.insert(
        0,
        {
          'from': fromVertex,
          'to': current,
          'weight': _adjacencyList[fromVertex]![current]!.weight,
          'direction': _adjacencyList[fromVertex]![current]!.direction,
        },
      );
      current = fromVertex;
    }

    return path;
  }
}

class Node {
  String vertex;
  int cost;

  Node(this.vertex, this.cost);
}
