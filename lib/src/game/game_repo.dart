import 'dart:convert';

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/settings/setting_repo.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:drag_drop/src/utils/isar_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final timeProvider = StateProvider((ref) => 120);

class SubmitSolutionResponse {
  final int rank;
  final int score;
  final String bestTime;
  final int statusCode;
  SubmitSolutionResponse({
    required this.rank,
    required this.score,
    required this.statusCode,
    required this.bestTime,
  });
}

Future<SubmitSolutionResponse> submitSolution(
    String time, int levelNumber, WidgetRef ref) async {
  final response =
      await http.post(Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.submit),
          headers: {
            'Content-Type': 'application/json',
            "Authorization":
                "Bearer ${await (EncryptedStorage().read(key: EncryptedStorageKey.jwt.value))}"
          },
          body: jsonEncode({
            "time": time,
            "level_number": levelNumber,
          }));

  var data = jsonDecode(response.body);
  int rank = data["Rank"];
  int score = data["Score"];

  String bestTime = "-";
  try {
    bestTime = data["BestCompletition"].toString().split(" ")[1];
  } catch (e) {}

  GLOBAL_RANK = rank;
  GLOBAL_STARS = score;

  await EncryptedStorage()
      .write(key: EncryptedStorageKey.rank.value, value: rank.toString());
  await setStarsIsar(levelNumber, score);

  ref.invalidate(starsHomeScreenProvider);
  ref.invalidate(myRankHomeScreenProvider);

  return SubmitSolutionResponse(
    bestTime: bestTime,
    rank: rank,
    score: score,
    statusCode: response.statusCode,
  );
}
