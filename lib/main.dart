import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/login/login_screen.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

bool enableHaptics = true;
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  final jwt = await EncryptedStorage().read(key: 'jwt');
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

  runApp(App(showLoginScreen: showLoginScreen));
}

class App extends StatelessWidget {
  final bool showLoginScreen;
  const App({super.key, required this.showLoginScreen});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: MaterialApp(
        home: (showLoginScreen)
            ? LoginScreen()
            : HomeScreen(
                currentNumberOfStars: 12,
                lastLevelCompleted: 7,
                totalNumberOfLevels: 20,
              ),
      ),
    );
  }
}
