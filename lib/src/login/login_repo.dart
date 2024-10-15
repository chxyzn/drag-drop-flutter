import 'dart:convert';

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/constants/enums.dart';
import 'package:drag_drop/src/home/home_repo.dart';
import 'package:drag_drop/src/login/login_screen.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

class SignUpModel {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final int age;

  SignUpModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'age': age,
    };
  }

  Future<String> signUp() async {
    final response = await http.post(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.signUp),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(this.toJson()),
    );

    if (response.statusCode == 200) {
      return "Success";
    }
    if (response.statusCode ~/ 100 == 4) {
      return "Failed with status code ${response.statusCode}";
    }
    if (response.statusCode ~/ 100 == 5) {
      return "Server error";
    } else {
      return ('Failed to sign up');
    }
  }
}

class LoginModel {
  final String username;
  final String password;

  LoginModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username.trim(),
      'password': password.trim(),
    };
  }

  Future<(LoginResponseModel?, int)> login(WidgetRef ref) async {
    final response = await http.post(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(this.toJson()),
    );

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final user = User(
            username: data['user']['username'],
            firstName: data['user']['firstname'],
            lastName: data['user']['lastname'],
            email: data['user']['email'],
            age: data['user']['age'],
            totalScore: data['user']['totalScore'],
            currentRank: data["CurrentRank"]);

        ref.invalidate(starsLoginScreenProvider);
        ref.invalidate(myRankHomeScreenProvider);

        return (
          LoginResponseModel(
            accessToken: data['accessToken'],
            user: user,
          ),
          response.statusCode
        );
      } else {
        return (null, response.statusCode);
      }
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception('Failed to login');
    }
  }
}

class LoginResponseModel {
  final String accessToken;
  final User user;

  LoginResponseModel({
    required this.accessToken,
    required this.user,
  });
}

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final int totalScore;
  final int currentRank;

  User({
    required this.username,
    required this.firstName,
    required this.currentRank,
    required this.lastName,
    required this.email,
    required this.age,
    required this.totalScore,
  });
}

class LevelOverview {
  final int level;
  final int stars;
  final bool isCompleted;
  final bool isNext;

  LevelOverview({
    required this.level,
    required this.stars,
    required this.isCompleted,
    required this.isNext,
  });
}

Future<void> logout(BuildContext context) async {
  await EncryptedStorage().deleteAll();

  final isar = Isar.getInstance('levels');
  await isar!.writeTxn(() async {
    await isar.clear();
  });

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
}

Future<void> deleteAccount(BuildContext context) async {
  final response = await http.delete(
    Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.userDelete),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization":
          "Bearer ${await (EncryptedStorage().read(key: EncryptedStorageKey.jwt.value))}"
    },
  );

  if (response.statusCode == 200) {
    await logout(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete account'),
      ),
    );
  }
}
