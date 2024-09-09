import 'dart:convert';

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/login/login_repo.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class LeaderboardItem {
  final String name;
  final int rank;
  final int score;

  LeaderboardItem(
      {required this.name, required this.rank, required this.score});

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
        name: json['username'], rank: json['rank'], score: json['total_score']);
  }
}

Future<(List<LeaderboardItem>, int)> getLeaderboard(
    BuildContext context) async {
  final response = await http.get(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.leaderboard),
      headers: {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${await (EncryptedStorage().read(key: EncryptedStorageKey.jwt.value))}"
      });

  List<LeaderboardItem> leaderboard = [];
  print(response.body);

  if (response.statusCode == 401) {
    logout(context);
  }

  for (var item in jsonDecode(response.body)["LeaderBoard"]) {
    LeaderboardItem leaderboardItem = LeaderboardItem.fromJson(item);
    leaderboard.add(leaderboardItem);
  }
  return (leaderboard, jsonDecode(response.body)["YourRank"] as int);
}
