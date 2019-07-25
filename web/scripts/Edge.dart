import 'dart:svg';

import 'DraggableNode.dart';
import 'Graph.dart';

class Edge {
    int node1ID;
    int node2ID;
    String fillColor;
    Graph graph;
    //can change the width here to convey connectedness
    int width;
    Edge(Graph this.graph, this.node1ID, this.node2ID, {this.fillColor: "#ff0000", this.width: 2}) {
        graph.allEdges.add(this);
    }
    LineElement line;

    void setup() {
        print("setting up edge");
        line = LineElement();
        //TODO calculate my two points based on where my two nodes are
        DraggableNode node1 = graph.allNodes[node1ID];
        DraggableNode node2 = graph.allNodes[node2ID];
        //for now just put it at x/y and see what happens
        line.attributes["x1"]= "${node1.x+node1.width/2}";
        line.attributes["y1"]= "${node1.y+node1.height}";
        line.attributes["x2"]= "${node2.x+node2.width/2}";
        line.attributes["y2"]= "${node2.y+node2.height}";
        line.attributes["stroke-width"]= "$width";
        line.attributes["stroke"] = fillColor;


    }

    void render(SvgElement svg) {
        svg.append(line);

    }
}