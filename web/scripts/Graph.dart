import 'dart:svg';
import 'package:CommonLib/Random.dart';
import 'DraggableNode.dart';
import 'Edge.dart';

class Graph {
    Map<int, DraggableNode> allNodes = new Map<int, DraggableNode>();
    List<Edge> allEdges = List<Edge>(); //make sure to load all edges SECOND cuz they rely on nodes
    SvgElement _container;
    SvgElement get container {
        if(_container == null) {
            _container = SvgElement.tag("svg"); //removing 'new' bothers me on a fundamental level
            _container.classes.add("conspiracyBoard");
            _container.attributes["width"] = "1000";
            _container.attributes["height"] = "1000";
        }
        return _container;
    }

    void distributeNodes() {
        //put all the nodes in random places within the graph
        Random rand = Random();
        for(DraggableNode node in allNodes.values) {
            node.x = rand.nextIntRange(50,int.parse(_container.attributes["width"]));
            node.y = rand.nextIntRange(50,int.parse(_container.attributes["height"]));
        }

        for(Edge edge in allEdges) {
            edge.syncToNodes();
        }
    }

    void render() {
        for(DraggableNode node in allNodes.values) {
            node.render(container);
        }

        for(Edge edge in allEdges) {
            edge.render(container);
        }
    }
}