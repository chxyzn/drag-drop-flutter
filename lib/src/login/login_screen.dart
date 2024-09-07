import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/levels/levels_repo.dart';
import 'package:drag_drop/src/login/login_repo.dart';
import 'package:drag_drop/src/login/signup_screen.dart';
import 'package:drag_drop/src/settings/setting_repo.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late bool _passwordVisible;
  bool showLoader = false;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleLoader() {
    setState(() {
      showLoader = !showLoader;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      backgroundImage: DecorationImage(
        image: AssetImage(PngAssets.loginBackground),
        fit: BoxFit.cover,
      ),
      body: [
        SizedBox(
          height: 24.h,
        ),
        Image.asset(
          PngAssets.gplanLogo,
          width: 150.w,
          height: 150.h,
        ),
        Text(
          'GPLAN',
          style: w600.size50.copyWith(color: CustomColor.primaryColor),
        ),
        Text(
          'The Game',
          style: w600.size20.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Login',
          style: w700.size24.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Username',
            style: w500.size16.copyWith(color: CustomColor.primary60Color),
          ),
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1, color: CustomColor.primaryColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1, color: CustomColor.primaryColor),
            ),
            fillColor: CustomColor.textfieldBGColor,
            filled: true,
          ),
          style: w500.size18.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Password',
            style: w500.size16.copyWith(color: CustomColor.primary60Color),
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide:
                    BorderSide(width: 1, color: CustomColor.primaryColor),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide:
                    BorderSide(width: 1, color: CustomColor.primaryColor),
              ),
              fillColor: CustomColor.textfieldBGColor,
              filled: true,
              suffixIcon: IconButton(
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )),
          obscureText: !_passwordVisible,
          style: w500.size18.copyWith(color: CustomColor.primaryColor),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: w500.size16.copyWith(color: CustomColor.primaryColor),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Consumer(builder: (context, ref, child) {
          return GestureDetector(
            onTap: (showLoader)
                ? null
                : () async {
                    toggleLoader();
                    try {
                      LoginModel loginModel = LoginModel(
                          username: usernameController.text,
                          password: passwordController.text);

                      final result = await loginModel.login(ref);

                      print(result.$1);
                      print(result.$2);

                      if (result.$2 ~/ 100 == 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Invalid username or password",
                            style:
                                w700.size16.copyWith(color: CustomColor.white),
                          ),
                        ));
                        toggleLoader();
                        return;
                      }
                      if (result.$2 ~/ 100 == 5) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Server error",
                            style:
                                w700.size16.copyWith(color: CustomColor.white),
                          ),
                        ));
                        toggleLoader();
                        return;
                      }

                      await EncryptedStorage()
                          .write(key: "jwt", value: result.$1!.accessToken);

                      await getAllLevels(context);
                      GLOBAL_FIRSTNAME = result.$1!.user.firstName;
                      GLOBAL_LASTNAME = result.$1!.user.lastName;
                      GLOBAL_EMAIL = result.$1!.user.email;

                      GLOBAL_STARS = result.$1!.user.totalScore;

                      await EncryptedStorage().write(
                          key: "firstname", value: result.$1!.user.firstName);
                      await EncryptedStorage().write(
                          key: "lastname", value: result.$1!.user.lastName);
                      await EncryptedStorage()
                          .write(key: "email", value: result.$1!.user.email);

                      await EncryptedStorage().write(
                          key: "stars",
                          value: result.$1!.user.totalScore.toString());
                      await EncryptedStorage().write(
                          key: "rank",
                          value: result.$1!.user.currentRank.toString());

                      ref.invalidate(starsHomeScreenProvider);
                      ref.invalidate(myRankHomeScreenProvider);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => HomeScreen(
                                openedFromLogin: true,
                              )),
                        ),
                      );
                      toggleLoader();
                    } catch (e, s) {
                      print(s);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Error ${e.toString()}",
                          style: w700.size16.copyWith(color: CustomColor.white),
                        ),
                      ));
                      toggleLoader();
                    }
                  },
            child: Container(
              width: 150.w,
              decoration: BoxDecoration(
                  color: CustomColor.primaryColor,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: (showLoader)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: LinearProgressIndicator(
                            color: CustomColor.white,
                          ),
                        )
                      : Text(
                          'Login',
                          style: w700.size18.colorWhite,
                        ),
                ),
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: RichText(
                text: TextSpan(
                    text: "Don't have an account?",
                    style:
                        w700.size14.copyWith(color: CustomColor.primary60Color),
                    children: <InlineSpan>[
                  TextSpan(
                      text: ' Sign Up',
                      style: w700.size14
                          .copyWith(color: CustomColor.primaryColor)),
                ])),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            "Hipster ipsum tattooed brunch I'm baby. Plant venmo vape squid intelligentsia glossier fanny tilde ",
            textAlign: TextAlign.center,
            style: w700.size12.copyWith(color: CustomColor.primary60Color),
          ),
        ),
      ],
    );
  }
}
