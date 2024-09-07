import 'package:drag_drop/src/login/login_repo.dart';
import 'package:isar/isar.dart';

part 'isar_storage.g.dart';

@collection
class IsarLevel {
  late Id id;

  late int stars;
}

Future<void> setLevelsIsar(List<LevelOverview> levels) async {
  final isar = Isar.getInstance('levels');

  for (var level in levels) {
    final newLevel = IsarLevel()
      ..id = level.level
      ..stars = level.stars;

    await isar!.writeTxn(() async {
      await isar.isarLevels.put(newLevel);
    });
  }
}

Future<int> getStarsIsar(int level) async {
  final isar = Isar.getInstance('levels');

  final levelData = await isar!.isarLevels.get(level);

  if (levelData != null) {
    return levelData.stars;
  } else {
    return 0;
  }
}

Future<void> setStarsIsar(int level, int stars) async {
  final isar = Isar.getInstance('levels');

  final levelData = await isar!.isarLevels.get(level);

  if (levelData != null) {
    await isar.writeTxn(() async {
      levelData.stars = stars;
      await isar.isarLevels.put(levelData);
    });
  } else {
    final newLevel = IsarLevel()
      ..id = level
      ..stars = stars;

    await isar.writeTxn(() async {
      await isar.isarLevels.put(newLevel);
    });
  }
}

Future<int> getTotalStarsIsar() async {
  final isar = Isar.getInstance('levels');

  final levels = await isar!.isarLevels.filter().idGreaterThan(0).findAll();

  int totalStars = 0;
  for (var level in levels) {
    totalStars += level.stars;
  }

  print("sending total stars $totalStars");
  return totalStars;
}
