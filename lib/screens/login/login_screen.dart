import 'package:flutter/material.dart';

// Đây là một màn hình giả lập để điều hướng đến
// Bạn sẽ thay thế nội dung này bằng Màn hình Đăng nhập thật
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Màn hình Đăng nhập")),
      body: const Center(
        child: Text("Đây là trang Đăng nhập", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
