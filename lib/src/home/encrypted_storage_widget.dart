import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EncryptedStorageWidget extends ConsumerWidget {
  final String value;
  final FutureProvider provider;
  final Widget Function(String) child;
  const EncryptedStorageWidget(
      {super.key,
      required this.child,
      required this.provider,
      required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(provider).when(data: (data) {
      return child(data.toString());
    }, loading: () {
      return SizedBox();
    }, error: (error, stackTrace) {
      return SizedBox();
    });
  }
}
