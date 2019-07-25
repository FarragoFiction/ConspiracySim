import 'dart:html';
import 'dart:svg';

import 'DraggableNode.dart';
import 'Graph.dart';
Element div = querySelector('#output');
void main() {
  Graph graph = new Graph();
  div.append(graph.container);
  DraggableNode a = DraggableNode(graph,"A");
  DraggableNode hello = DraggableNode(graph,"Hello", x:250, y:400);
  a.attachToNode(hello);
  DraggableNode world = DraggableNode(graph,"To The World", x: 400);
  a.attachToNode(world,color: "#0000ff", size: 4);
  DraggableNode world2 = DraggableNode(graph,"Goodbye", x: 300,y:700);
  hello.attachToNode(world2);

  graph.render();

}
