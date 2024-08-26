import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/login/login_screen.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:drag_drop/src/utils/isar_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

bool enableHaptics = true;
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  final jwt = await EncryptedStorage().read(key: 'jwt');
  print(jwt);
  bool showLoginScreen = true;
  String? haptics = await EncryptedStorage().read(key: 'haptics');

  if (haptics == null || haptics == 'true') {
    enableHaptics = true;
  } else {
    enableHaptics = false;
  }

  if (jwt != null) {
    showLoginScreen = false;
  }

  final dir = await getApplicationDocumentsDirectory();
  await Isar.open(
    [IsarLevelSchema],
    directory: dir.path,
    name: "levels",
    inspector: true,
  );

  runApp(App(showLoginScreen: showLoginScreen));
}

class App extends StatelessWidget {
  final bool showLoginScreen;
  const App({super.key, required this.showLoginScreen});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: ProviderScope(
        child: MaterialApp(
          home: (showLoginScreen) ? LoginScreen() : HomeScreen(),
        ),
      ),
    );
  }
}
