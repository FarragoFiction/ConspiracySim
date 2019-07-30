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
  String phrases = "warning,pvpisnotglitch,exilethebody,echidnaScience,yearnfulNode10,yearnfulNode1,herstory,so_fucking_meta,smokey,smokeyEternal,jr_is_a_jar,svg,tin,metametameta,karmicRetribution10,ab_alchemized,cheetoTimeline5,cheetoTimeline1,birdRealm0,coward_and_a_fraud,sorry about the buttons,CaseStudy_Unused,echidnamilk,CaseStudy_Hands,charming,asdfghjkl,sburbsimyellowyard1,what_is_farragnarok,fuck0,heart_clover_star,songs_to_code_by_jrs_lament_cipah,lomat_by_fan_gnome,,113,nebulore,fan_raf_conspiracy_theory,argsaremypassion,echidnalaugh,turtles2,fan_cd_waste,inheritance,giggle_reading_neb_is_great,waste_of_void,About_Void,ProgrammingJourney,cthulhu_mixdown,cthulhu_mistake,abspiel,abconcerns,all_jr_headcanons,sage_advice_noodle,giggle_reading_own_troll_planet_8,jingle_lore,lomat_nearly_done";
  //for now, just load this test set
  String passPhrase = Uri.base.queryParameters['passPhrase'];

  final dynamic jsonRet = await Loader.getResource(
      "http://farragofiction.com:85/GetEdges?phrases=$phrases", format: Formats.json);
  Edge.loadJSONForMultipleEdges(graph, jsonRet);
  graph.pruneToPhraseAndEdges(passPhrase);
}
