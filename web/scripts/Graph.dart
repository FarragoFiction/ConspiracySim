import 'dart:svg';
import 'package:CommonLib/Random.dart';
import 'DraggableNode.dart';
import 'Edge.dart';
import 'dart:math' as Math;

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

    void distributeNodesCircles() {
        //first, sort nodes by number of edges
        final List<DraggableNode> nodes = new List<DraggableNode>.from(allNodes.values);
        print("nodes is $nodes");
        nodes.sort((a, b) => b.edges.length.compareTo(a.edges.length));
        startCenterRecurse(nodes);
        for(final Edge edge in allEdges) {
            edge.syncToNodes();
        }
    }

    void startCenterRecurse(List<DraggableNode> nodes) {
        final DraggableNode node = nodes.first;
        node.handleMove(350, 400);
        nodes.remove(node);
        handleCenterRecurse(nodes, node, node);
    }


    //if you aren't the origin node, when you place children, make sure to avoid placing things pointed towards the origin
    void handleCenterRecurse(List<DraggableNode> nodes, DraggableNode centerNode, DraggableNode originNode) {
        //then, take all the nodes linked to it, and place THEM at regular angles around
        //the center
        //make sure to mark them as having been placed.
        //then, recurse on each of them, placing THEIR children only in the 180 degrees

        //first divide 360 (or 180) degrees by how many edges there are
        final int anglePerNode = (360/centerNode.edges.length).ceil();
        print("angles would be $anglePerNode");
        List<DraggableNode> connections = centerNode.connections;
        int currentAngle = 0;
        int radius = 200; //TODO calculate this to be longer if angle is smaller
        for(final DraggableNode node in connections) {
            print("currentAngle is $currentAngle");
            final int x = calculateXFromAngle(currentAngle, centerNode.x, radius);
            final int y = calculateXFromAngle(currentAngle, centerNode.y, radius);
            node.handleMove(x,y);
            currentAngle += anglePerNode;
            //TODO recursively call startcenter recurse on this, with this as the center node and origin as origin

        }
        //then, figure out what angle each edge needs to be at
        //take the angle and arcsin and arccosin to figure out
        // what x/y to put it at (multiplied by a distance needed to get them far enough from each other)
        //then, call this method with each node as the center node

    }

    int calculateXFromAngle(int angle, int x, int radius) {
        return (x + (radius * Math.sin(angle * Math.pi/180)).ceil());

    }

    int calculateYFromAngle(int angle, int y, int radius) {
        return (y +  (radius *Math.cos(angle * Math.pi/180)).ceil());

    }

    void distributeNodesGrid() {
        //first, sort nodes by number of edges
        final List<DraggableNode> nodes = new List<DraggableNode>.from(allNodes.values);
        print("nodes is $nodes");
        nodes.sort((a, b) => b.edges.length.compareTo(a.edges.length));
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