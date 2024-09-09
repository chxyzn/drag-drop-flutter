import 'dart:convert';

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/login/login_repo.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:drag_drop/src/utils/isar_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<
    (
      List<Map<String, dynamic>>,
      List<int>,
      List<List<int>>,
      int,
      int,
      String,
      String,
    )> getLevel({required int id, required BuildContext context}) async {
  final response = await http.get(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.levels + '/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${await (EncryptedStorage().read(key: EncryptedStorageKey.jwt.value))}"
      });

  if (response.statusCode == 401) {
    logout(context);
  }

  var data = jsonDecode(response.body);
  var graphString = jsonDecode(response.body)["graph"];
  var graphData = jsonDecode(graphString);

  List<Map<String, dynamic>> nodes = [];
  List<int> questionNodes = [];
  List<List<int>> questionEdges = [];

  for (var element in graphData['nodes']) {
    nodes.add(element as Map<String, dynamic>);
  }

  List apiNodes = graphData['nodes'];
  for (var element in apiNodes) {
    questionNodes.add(element['id'] as int);
  }

  List apiEdges = graphData['edges'];
  for (var element in apiEdges) {
    List<int> vertices = List.from(element);
    questionEdges.add(vertices);
  }

  return (
    nodes,
    questionNodes,
    questionEdges,
    data["grid"]["row_size"] as int,
    data["grid"]["column_size"] as int,
    data["hint"] as String,
    data["BestComletitionTime"] as String,
  );
}

class NodeModel {
  final int id;
  final List<List<int>> shape;

  NodeModel({required this.id, required this.shape});
}

class EdgeModel {
  final List<int> vertices;

  EdgeModel({required this.vertices});
}

Future<(List<LevelOverview>, int, String)> getAllLevels(
    BuildContext context) async {
  final http.Response response = await http.get(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.allLevels),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization":
            "Bearer ${await (EncryptedStorage().read(key: EncryptedStorageKey.jwt.value))}"
      });

  if (response.statusCode == 401) {
    logout(context);
  }
  try {
    List levelsData = jsonDecode(response.body)["Levels"];
    List<LevelOverview> levels = [];

    bool previousLevelComplete = false;
    bool currentLevelComplete = false;

    for (int i = 0; i < levelsData.length; i++) {
      bool isNxt = false;
      if (i == 0) {
        currentLevelComplete = levelsData[i]["completed"];
        previousLevelComplete = currentLevelComplete;

        levels.add(LevelOverview(
          level: levelsData[i]["levelNumber"],
          stars: levelsData[i]["score"],
          isCompleted: levelsData[i]["completed"],
          isNext: currentLevelComplete ? false : true,
        ));
        continue;
      }
      currentLevelComplete = levelsData[i]["completed"];
      if (previousLevelComplete && !currentLevelComplete) {
        isNxt = true;
      }
      previousLevelComplete = currentLevelComplete;
      levels.add(LevelOverview(
        level: levelsData[i]["levelNumber"],
        stars: levelsData[i]["score"],
        isCompleted: levelsData[i]["completed"],
        isNext: isNxt,
      ));
    }

    await setLevelsIsar(levels);

    return (levels, response.statusCode, "");
  } catch (e) {
    var x =
        Future.value((<LevelOverview>[], response.statusCode, e.toString()));
    return x;
  }
}
