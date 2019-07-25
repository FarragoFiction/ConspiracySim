
import 'dart:html';
import 'dart:svg';
import 'package:CommonLib/Collection.dart';

import 'Edge.dart';
import 'Graph.dart';
class DraggableNode {
    EllipseElement node;
    static int lastId = 0; //load from save
    SvgElement group;
    int id;
    List<Edge> edges;
    int height;
    int width;
    int x;
    int y;
    int fontSize = 20;
    String text;
    TextElement textElement;
    Graph graph;


    DraggableNode(Graph this.graph, String this.text, {this.edges: null, this.height: 50, this.x: 100, this.y:100}) {
        id = lastId;
        graph.allNodes[id] = this;
        lastId ++;
        edges ??= List<Edge>();
        //can get pair to get the weight out.
        setupGroup();
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

    }

    void attachToNode(DraggableNode other, {String color: "#ff0000", int size:2}) {
        if(this == other) {
            window.console.warn("Look. Don't attach a node to itself. Bad things happen when your conspiracies are THAT convoluted.");
        }
        Edge edge = Edge(graph,this.id, other.id, fillColor: color, width: size);
        edges.add(edge);
        other.edges.add(edge);
        edge.setup();
    }


    void setupText() {
      textElement = TextElement()..text = text;
      textElement.attributes["fill"] = "#00ff00";
      int width = textToWidth(text, fontSize);
      textElement.attributes["x"]= "${width/4}";
      textElement.attributes["y"]= "${height*1.1}";
      textElement.attributes["font-size"]= "${fontSize}";
      group.append(textElement);

    }

    void setupNode() {
        node = new EllipseElement();
        width = textToWidth(text, fontSize);
        node.attributes["rx"] = "${width}";
        node.attributes["ry"] = "$height";
        node.attributes["cx"] = "${width}";
        node.attributes["cy"] = "${height}";
        node.attributes["fill"] = "#ffffff";
        node.attributes["stroke"] = "#000000";

        node.onMouseDown.listen((MouseEvent e) {
            node.attributes["fill"] = "#ff0000";
        });

        node.onMouseUp.listen((MouseEvent e) {
            node.attributes["fill"] = "#ffffff";
        });
        group.append(node);
    }
}
