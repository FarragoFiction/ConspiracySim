import 'dart:svg';
import 'package:CommonLib/Random.dart';
import 'DraggableNode.dart';
import 'Edge.dart';

class Graph {
    Map<String, DraggableNode> allNodes = new Map<String, DraggableNode>();
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
        distributeNodesGrid();
    }

    void distributeNodesGrid() {
        //first, sort nodes by number of edges
        final List<DraggableNode> nodes = new List<DraggableNode>.from(allNodes.values);
        print("nodes is $nodes");
        nodes.sort((a, b) => a.edges.length.compareTo(b.edges.length));
        for(int x = 0; x<800; x+=300) {
            for(int y = 0; y<1000; y+=100) {
                if(nodes.isNotEmpty) {
                    nodes.first.handleMove(x, y);
                    nodes.remove(nodes.first);
                }else {
                    break;
                }
            }
        }
        for(final Edge edge in allEdges) {
            edge.syncToNodes();
        }
    }

    void distributeNodesRandom() {
        print("graph is handling deciding where nodes go");
        //put all the nodes in random places within the graph
        final Random rand = Random();
        for(DraggableNode node in allNodes.values) {
            final int x = rand.nextIntRange(50,950);
            final int y = rand.nextIntRange(50,950);
            node.handleMove(x,y);
        }
        print("there are this many edge: ${allEdges.length}");
        for(final Edge edge in allEdges) {
            edge.syncToNodes();
        }
    }

    void render() {


        for(final Edge edge in allEdges) {
            edge.render(container);
        }

        for(final DraggableNode node in allNodes.values) {
            node.render(container);
        }
    }
}