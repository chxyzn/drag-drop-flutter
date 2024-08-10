import 'dart:convert';

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:http/http.dart' as http;

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
      'username': username,
      'password': password,
    };
  }

  Future<(LoginResponseModel, int)> login() async {
    final response = await http.post(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(this.toJson()),
    );

    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final user = User(
        username: data['user']['username'],
        firstName: data['user']['firstname'],
        lastName: data['user']['lastname'],
        email: data['user']['email'],
        age: data['user']['age'],
      );

      final List<LevelOverview> levels = [];
      for (final level in data['levels']) {
        levels.add(LevelOverview(
          level: level['level'],
          stars: level['stars'],
          isCompleted: level['isCompleted'],
        ));
      }

      return (
        LoginResponseModel(
          accessToken: data['accessToken'],
          user: user,
          levels: levels,
        ),
        response.statusCode
      );
    } catch (e) {
      throw Exception('Failed to login');
    }
  }
}

class LoginResponseModel {
  final String accessToken;
  final User user;
  final List<LevelOverview> levels;

  LoginResponseModel({
    required this.accessToken,
    required this.user,
    required this.levels,
  });
}

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int age;

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
  });
}

class LevelOverview {
  final int level;
  final int stars;
  final bool isCompleted;

  LevelOverview({
    required this.level,
    required this.stars,
    required this.isCompleted,
  });
}

void something() {
  String s =
      "{\"nodes\":[{\"id\":1,\"shape\":[[1,0],[0,0]]},{\"id\":2,\"shape\":[[0,1],[0,0]]},{\"id\":3,\"shape\":[[0,0],[1,1]]}],\"edges\":[[1,2],[3,2],[3,1]]}";
  Map<String, dynamic> data = jsonDecode(s);
  print(data);
  print(data['nodes']);
  print(data['nodes'].first['id']);
}
