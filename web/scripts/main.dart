import 'dart:html';
import 'dart:svg';
import 'package:LoaderLib/Loader.dart';

import 'DraggableNode.dart';
import 'Edge.dart';
import 'Graph.dart';
Element div = querySelector('#output');
Future<void> main() async {
  Loader.init();
  Graph graph = Graph();
  div.append(graph.container);


  /*
  DraggableNode a = DraggableNode(graph,"A");
  DraggableNode hello = DraggableNode(graph,"Hello", x:250, y:400);
  a.attachToNode(hello);
  DraggableNode world = DraggableNode(graph,"To The World", x: 400);
  a.attachToNode(world,color: "#0000ff", size: 8);
  DraggableNode world2 = DraggableNode(graph,"Goodbye", x: 300,y:700);
  hello.attachToNode(world2);
*/
  await loadPassPhrases(graph);
  graph.distributeNodes();
  graph.render();

}

Future<void> loadPassPhrases(Graph graph) async {
  //http://farragofiction.com:85/GetEdges?phrases=warning,weird,echidnas,echidnamilk
  final String knownKey = "AUDIOLOGSCASETTELIBRARY";
  String phrases;
  if(window.localStorage.containsKey(knownKey)){
    print("loading phrases from local storage");
    phrases = window.localStorage[knownKey]; //for now, just load this test set
  }else{
    print("using default phrases");
    phrases = "warning,weird,echidnas,echidnamilk,hello_world,first";
  }
  final  String passPhrase = Uri.base.queryParameters['passPhrase'];
  print("phrases are $phrases");
  final dynamic jsonRet = await Loader.getResource(
      "http://farragofiction.com:85/GetEdges?phrases=$phrases", format: Formats.json);
  Edge.loadJSONForMultipleEdges(graph, jsonRet);
  if(passPhrase != null) {
    graph.pruneToPhraseAndEdges(passPhrase);
  }
}
