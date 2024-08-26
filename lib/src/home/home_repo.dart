import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:drag_drop/src/utils/isar_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myRankHomeScreenProvider =
    FutureProvider((ref) => EncryptedStorage().read(key: 'rank'));

final starsHomeScreenProvider = FutureProvider((ref) => getTotalStarsIsar());
final starsLoginScreenProvider =
    FutureProvider((ref) => EncryptedStorage().read(key: "stars"));
