import 'dart:html';
import 'dart:svg';
Element div = querySelector('#output');
void main() {
  SvgElement svg = DraggableNode.container;
  div.append(svg);
  svg.append(DraggableNode("Hello").node);
  svg.append(DraggableNode("World", x:250).node);
  svg.append(DraggableNode("Goodbye", x: 400).node);

}

class DraggableNode {
  EllipseElement node;
  int width;
  int height;
  int x;
  int y;
  String text;

  static SvgElement _container;
  static SvgElement get container {
    if(_container == null) {
      _container = SvgElement.tag("svg"); //removing 'new' bothers me on a fundamental level
      _container.attributes["width"] = "1000";
      _container.attributes["height"] = "1000";
    }
    return _container;
  }

  DraggableNode(String this.text, {this.width: 100, this.height: 50, this.x: 100, this.y:100}) {
    node = new EllipseElement();
    node.attributes["rx"] = "$width";
    node.attributes["ry"] = "$height";
    node.attributes["cx"] = "$x";
    node.attributes["cy"] = "$y";
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
