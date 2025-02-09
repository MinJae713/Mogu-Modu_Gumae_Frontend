import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
    );
  }
}

class UserViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // 로딩 상태 업데이트

    // try {
    //   final response = await http.get(Uri.parse("https://api.example.com/user"));
    //
    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> data = json.decode(response.body);
    //     _user = User.fromJson(data);
    //   } else {
    //     _errorMessage = "데이터를 불러오지 못했습니다.";
    //   }
    // } catch (e) {
    //   _errorMessage = "네트워크 오류가 발생했습니다.";
    // }
    final Map<String, dynamic> data = {
      'name': '유민재',
      'age': 27
    };
    _user = User.fromJson(data);
    _isLoading = false;
    notifyListeners(); // 데이터 업데이트
  }
  void initUser() {
    _user = User(name: "유민둥", age: 20);
  }
}

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.user == null)
      userViewModel.initUser();
    return Scaffold(
      appBar: AppBar(title: Text("MVVM Example")),
      body: Center(
        child: userViewModel.isLoading
            ? CircularProgressIndicator() // 로딩 표시
            : userViewModel.errorMessage != null
            ? Text("오류: ${userViewModel.errorMessage}") // 에러 메시지 표시
            : userViewModel.user == null
            ? Text("데이터 없음")
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("이름: ${userViewModel.user!.name}"),
            Text("나이: ${userViewModel.user!.age}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => userViewModel.fetchUser(),
              child: Text("사용자 정보 불러오기"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => UserViewModel(),
  //     child: MaterialApp(home: UserScreen()),
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserViewModel()
        )
      ],
      child: MaterialApp(home: UserScreen()),
    )
  );
}