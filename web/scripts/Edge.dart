import 'dart:svg';

import 'package:CommonLib/Utility.dart';

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

    Edge.fromJSON(Graph graph,dynamic jsonRet){
        final JsonHandler json = new JsonHandler(jsonRet);
        String node1String = json.getValue("passPhrase1");
        String node2String = json.getValue("passPhrase2");
        DraggableNode node1;
        DraggableNode node2;
        width = json.getValue("weight");
        //if the node doesn't exist yet, it is necessary to create it
        if(graph.allNodes.containsKey(node1String)){
            node1 = graph.allNodes[node1String];
        }else{
            node1 = DraggableNode(graph, node1String);
        }

        if(graph.allNodes.containsKey(node2String)){
            node2 = graph.allNodes[node2String];
        }else{
            node2 = DraggableNode(graph, node2String);
        }
        //make sure the nodes know about you and vice versa
        node1.edges.add(this);
        node2.edges.add(this);
        node1ID = node1.id;
        node2ID = node2.id;

        setup();
    }

    //given a bunch of edges in json (not a list, but a hash), it will generate the nodes and edges needed
    static void loadJSONForMultipleEdges(Graph graph,dynamic jsonRet){
        final JsonHandler json = new JsonHandler(jsonRet);
        for(dynamic d in json.data.keys) {
            print("d is $d");
            (new Edge.fromJSON(graph,json.getValue(d)));
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
        line.attributes["y1"]= "${node1.y+node1.height}";
        line.attributes["x2"]= "${node2.x+node2.width/2}";
        line.attributes["y2"]= "${node2.y+node2.height}";

    }

    void render(SvgElement svg) {
        svg.append(line);

    }
}