import 'dart:html';
import 'dart:svg';
Element div = querySelector('#output');
void main() {
  SvgElement svg = DraggableNode.container;
  div.append(svg);
  svg.append(DraggableNode("Hello").rect);
  svg.append(DraggableNode("World", x:150).rect);
  svg.append(DraggableNode("Goodbye", x: 300).rect);

}

class DraggableNode {
  RectElement rect;
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

  DraggableNode(String this.text, {this.width: 100, this.height: 100, this.x: 0, this.y:0}) {
    rect = new RectElement();
    rect.attributes["width"] = "$width";
    rect.attributes["height"] = "$height";
    rect.attributes["x"] = "$x";
    rect.attributes["y"] = "$y";
    rect.attributes["fill"] = "#ffffff";
    rect.attributes["stroke"] = "#000000";

    rect.onMouseDown.listen((MouseEvent e) {
      rect.attributes["fill"] = "#ff0000";
    });

    rect.onMouseUp.listen((MouseEvent e) {
      rect.attributes["fill"] = "#ffffff";
    });
  }
}
