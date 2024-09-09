enum EncryptedStorageKey {
  jwt,
  haptics,
  firstname,
  lastname,
  recent,
  email,
  rank,
  stars
}

extension EncryptedStorageKeyExtension on EncryptedStorageKey {
  String get value {
    return this.toString().split('.').last;
  }
}
