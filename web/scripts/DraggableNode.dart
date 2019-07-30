
import 'dart:html';
import 'dart:svg';
import 'package:CommonLib/Collection.dart';
import 'package:CommonLib/Random.dart';

import 'Edge.dart';
import 'Graph.dart';

//TODO add natural sort of how many edges the node has

class DraggableNode {
    RectElement node;
    static int lastId = 0; //load from save
    SvgElement group;
    List<Edge> edges;
    int height;
    int width;
    int x;
    int y;
    int fontSize = 20;
    String text;
    TextElement textElement;
    Graph graph;
    String color;


    //TODO eventually graph will decide where to place nodes before rendering
    DraggableNode(Graph this.graph, String this.text, {this.edges: null, this.height: 50, this.x: 100, this.y:100}) {
        graph.allNodes[text] = this;
        lastId ++;
        edges ??= List<Edge>();
        final Random rand = new Random();
        color = "rgb(${rand.nextIntRange(0,255)},${rand.nextIntRange(0,255)},${rand.nextIntRange(0,255)})";
        //can get pair to get the weight out.
        setupGroup();
    }

    List<DraggableNode> get connections {
        List<DraggableNode> ret = new List<DraggableNode>();
        for(Edge edge in edges) {
            if(edge.node1ID == text) {
                ret.add(graph.allNodes[edge.node2ID]);
            }else {
                ret.add(graph.allNodes[edge.node1ID]);
            }
        }
        return ret;
    }

    void render(SvgElement svg) {
        svg.append(group);
    }

    static int textToWidth(String text, int fontSize) {
        return (text.length * fontSize*0.6).ceil();
    }

    void setupGroup() {
        group = SvgElement.tag("svg");
        //a nested svg can have x/y set, but a group needs a transform and i don't wanna deal with that
        group.attributes["x"]= "$x";
        group.attributes["y"]= "$y";
        setupNode();
        setupText();
        setupControls();

    }

    void attachToNode(DraggableNode other, {String color: "#ff0000", int size:2}) {
        if(this == other) {
            window.console.warn("Look. Don't attach a node to itself. Bad things happen when your conspiracies are THAT convoluted.");
        }
        Edge edge = Edge(graph,this.text, other.text, fillColor: color, width: size);
        edges.add(edge);
        other.edges.add(edge);
        edge.setup();
    }


    void setupText() {
      textElement = TextElement()..text = text;
      textElement.attributes["fill"] = "#00ff00";
      width = textToWidth(text, fontSize);
      textElement.attributes["x"]= "${width/2+10}";
      textElement.attributes["y"]= "${height*1.1}";
      textElement.attributes["font-size"]= "${fontSize}";
      group.append(textElement);

    }

    void setupControls() {
        group.onMouseDown.listen((MouseEvent e) {
            graph.draggingNode = this;
            node.attributes["fill"] = "#ff0000";
            node.style.zIndex = "1000";
        });


    }

    static DraggableNode  getNode(Graph graph, String text) {
        if(graph.allNodes.containsKey(text)){
            return graph.allNodes[text];
        }else{
            return DraggableNode(graph, text);
        }
    }

    void setupNode() {
        node = new RectElement();
        width = textToWidth(text, fontSize);
        node.attributes["width"] = "$width";
        node.attributes["height"] = "$height";
        node.attributes["x"] = "${width/2}";
        node.attributes["y"] = "${height/2}";
        node.attributes["fill"] = "#ffffff";
        node.attributes["stroke"] = "#000000";
        group.append(node);
    }

    void handleMove(int newX, int newY) {
        print("moving $text to $newX, $newY");
        x = newX;
        y = newY;
        group.attributes["x"] = "$x";
        group.attributes["y"] = "$y";
        for(Edge edge in edges) {
            edge.syncToNodes();
        }
    }
}
