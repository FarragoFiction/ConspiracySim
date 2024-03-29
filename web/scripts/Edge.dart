import 'dart:svg';

import 'package:CommonLib/Utility.dart';

import 'DraggableNode.dart';
import 'Graph.dart';

class Edge {
    //the text a node displays is guaranteed unique
    String node1ID;
    String node2ID;
    String fillColor;
    Graph graph;
    //can change the width here to convey connectedness
    int width;
    Edge(this.graph, this.node1ID, this.node2ID, {this.fillColor: "#ff0000", this.width: 2}) {
        graph.allEdges.add(this);
    }

    Edge.fromJSON(this.graph,dynamic jsonRet,{this.fillColor: "#ff0000"}){
        final JsonHandler json = new JsonHandler(jsonRet);
        node1ID = json.getValue("passPhrase1");
        node2ID = json.getValue("passPhrase2");
        width = json.getValue("weight");
        //if the node doesn't exist yet, it is necessary to create it
        DraggableNode node1 = DraggableNode.getNode(graph, node1ID);
        DraggableNode node2 = DraggableNode.getNode(graph, node2ID);

        //make sure the nodes know about you and vice versa
        node1.edges.add(this);
        node2.edges.add(this);
        graph.allEdges.add(this);
        fillColor = node1.color;
        setup();
    }

    //given a bunch of edges in json (not a list, but a hash), it will generate the nodes and edges needed
    static void loadJSONForMultipleEdges(Graph graph,dynamic jsonRet){
        int weightThreshold = 0;
        if(Uri.base.queryParameters['threshold'] != null) {
            weightThreshold = int.parse(Uri.base.queryParameters['threshold']);
        }
        print("threshold is $weightThreshold");
        final JsonHandler json = new JsonHandler(jsonRet);
        for(dynamic d in json.data.keys) {
            //print("d is $d");
            if(json.getValue(d)["weight"] >weightThreshold) {
                (new Edge.fromJSON(graph, json.getValue(d)));
            }
        }

    }
    LineElement line;

    void setup() {
        print("setting up edge");
        line = LineElement();
        line.attributes["stroke-width"]= "$width";
        line.attributes["stroke"] = fillColor;
        syncToNodes();
    }

    void syncToNodes() {
        DraggableNode node1 = graph.allNodes[node1ID];
        DraggableNode node2 = graph.allNodes[node2ID];
        //for now just put it at x/y and see what happens
        line.attributes["x1"]= "${node1.x+node1.width/2}";
        line.attributes["y1"]= "${node1.y+(node1.height*1.5).ceil()}";
        line.attributes["x2"]= "${node2.x+node2.width/2}";
        line.attributes["y2"]= "${node2.y+(node2.height*1.5).ceil()}";

    }

    void render(SvgElement svg) {
        svg.append(line);

    }
}