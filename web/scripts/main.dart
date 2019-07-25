import 'dart:html';
import 'dart:svg';

import 'DraggableNode.dart';
import 'Graph.dart';
Element div = querySelector('#output');
void main() {
  Graph graph = new Graph();
  div.append(graph.container);
  DraggableNode a = DraggableNode(graph,"A");
  DraggableNode hello = DraggableNode(graph,"Hello", x:250);
  a.attachToNode(hello);
  DraggableNode(graph,"To The World", x: 400);
  graph.render();

}
