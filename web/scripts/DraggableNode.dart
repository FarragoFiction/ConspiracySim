
import 'dart:html';
import 'dart:svg';

class DraggableNode {
    EllipseElement node;
    SvgElement group;
    //width is automatic
    int height;
    int x;
    int y;
    int fontSize = 20;
    String text;
    TextElement textElement;

    static SvgElement _container;
    static SvgElement get container {
        if(_container == null) {
            _container = SvgElement.tag("svg"); //removing 'new' bothers me on a fundamental level
            _container.attributes["width"] = "1000";
            _container.attributes["height"] = "1000";
        }
        return _container;
    }

    DraggableNode(String this.text, {this.height: 50, this.x: 100, this.y:100}) {
        setupGroup();
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

        group.append(node);
        group.append(textElement);
    }

    void setupText() {
      textElement = TextElement()..text = text;
      textElement.attributes["fill"] = "#00ff00";
      int width = textToWidth(text, fontSize);
      textElement.attributes["x"]= "${width/4}";
      textElement.attributes["y"]= "${height*1.1}";
      textElement.attributes["font-size"]= "${fontSize}";

    }

    void setupNode() {
        node = new EllipseElement();
        var width = textToWidth(text, fontSize);
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
    }
}
