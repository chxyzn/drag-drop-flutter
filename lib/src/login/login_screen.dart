import 'package:drag_drop/src/constants/Colors.dart';
import 'package:drag_drop/src/constants/assets.dart';
import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/home/home.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool _passwordVisible;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          controller: emailController,
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => HomeScreen(
                      currentNumberOfStars: 15,
                      lastLevelCompleted: 12,
                      totalNumberOfLevels: 34,
                    )),
              ),
            );
          },
          child: Container(
            width: 150.w,
            decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.circular(4.0)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Login',
                  style: w700.size18.colorWhite,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {},
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
