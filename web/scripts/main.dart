import 'dart:html';
import 'dart:svg';

import 'DraggableNode.dart';
Element div = querySelector('#output');
void main() {
  SvgElement svg = DraggableNode.container;
  div.append(svg);
  svg.append(DraggableNode("A").group);
  svg.append(DraggableNode("Hello", x:250).group);
  svg.append(DraggableNode("To The World", x: 400).group);

}
