import 'dart:html';
import 'dart:svg';
Element div = querySelector('#output');
void main() {
  querySelector('#output').text = 'Your Dart app is running.';
  SvgElement svg = new SvgElement.tag("svg");
  div.append(svg);
  DraggableNode node = new DraggableNode();
  svg.append(node.rect);
}

class DraggableNode {
  RectElement rect;
  int width = 100;
  int height = 100;

  DraggableNode() {
    rect = new RectElement();
    rect.attributes["width"] = "$width";
    rect.attributes["height"] = "$height";
    rect.attributes["fill"] = "#000000";

    rect.onMouseDown.listen((MouseEvent e) {
      rect.attributes["fill"] = "#ff0000";
    });

    rect.onMouseUp.listen((MouseEvent e) {
      rect.attributes["fill"] = "#000000";
    });
  }
}
