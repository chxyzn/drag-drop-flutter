import 'package:drag_drop/src/constants/textstyles.dart';
import 'package:drag_drop/src/login/login_repo.dart';
import 'package:drag_drop/src/login/login_screen.dart';
import 'package:drag_drop/src/utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/Colors.dart';
import '../constants/assets.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController confirmPasswordController;

  bool showLoader = false;
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  @override
  void initState() {
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _passwordVisible = false;
    _confirmPasswordVisible = false;

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String> onSubmit() async {
    String validationMessage = validateInput();
    if (validationMessage.isNotEmpty) {
      return validationMessage;
    }

    SignUpModel signUpModel = SignUpModel(
      username: usernameController.text,
      firstName: "",
      lastName: "",
      password: passwordController.text,
      age: 18,
    );

    String message = await signUpModel.signUp();

    return message;
  }

  String validateInput() {
    if (usernameController.text.isEmpty) {
      return 'Username cannot be empty';
    }
    if (passwordController.text.isEmpty) {
      return 'Password cannot be empty';
    }
    if (passwordController.text.length < 8) {
      return 'Password must be atleast 8 characters long';
    }

    if (confirmPasswordController.text.isEmpty) {
      return 'Confirm Password cannot be empty';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match';
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      verticalPadding: 24.h,
      backgroundColor: CustomColor.white,
      backgroundImage: DecorationImage(
        image: AssetImage(PngAssets.loginBackground),
        fit: BoxFit.cover,
      ),
      body: [
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
          height: 40.h,
        ),
        Text(
          'SignUp',
          style: w700.size24.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 20.h,
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
          height: 10.h,
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
        SizedBox(
          height: 10.h,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Confirm Password',
            style: w500.size16.copyWith(color: CustomColor.primary60Color),
          ),
        ),
        TextField(
          controller: confirmPasswordController,
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
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
                icon: Icon(
                  _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )),
          obscureText: !_confirmPasswordVisible,
          style: w500.size18.copyWith(color: CustomColor.primaryColor),
        ),
        SizedBox(
          height: 25.h,
        ),
        InkWell(
          onTap: (showLoader)
              ? null
              : () async {
                  try {
                    setState(() {
                      showLoader = true;
                    });
                    String message = await onSubmit();
                    if (message.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          message,
                          style: w700.size16.copyWith(color: CustomColor.white),
                        ),
                      ));
                    }
                    setState(() {
                      showLoader = false;
                    });
                    if (message == "Success") {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    }
                  } catch (e) {
                    setState(() {
                      showLoader = false;
                    });
                  }
                },
          child: Container(
            decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.circular(4.0)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: (showLoader)
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: LinearProgressIndicator(
                          color: CustomColor.white,
                        ),
                      )
                    : Text(
                        'Sign Up',
                        style: w700.size16.colorWhite,
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: RichText(
                text: TextSpan(
                    text: "Have an account?",
                    style:
                        w700.size14.copyWith(color: CustomColor.primary60Color),
                    children: <InlineSpan>[
                  TextSpan(
                      text: ' Login',
                      style: w700.size14
                          .copyWith(color: CustomColor.primaryColor)),
                ])),
          ),
        ),
      ],
    );
  }
}
