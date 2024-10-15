enum EncryptedStorageKey {
  jwt,
  haptics,
  firstname,
  lastname,
  recent,
  email,
  rank,
  stars,
  username
}

extension EncryptedStorageKeyExtension on EncryptedStorageKey {
  String get value {
    return this.toString().split('.').last;
  }
}
