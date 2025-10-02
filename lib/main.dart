import 'package:flutter/material.dart';
import 'package:smart_reader/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Book',
      home: const HomeScreen(),
      // home: const VideoDownloadScreen(),
      // home: const VideoScreen(),
    );
  }
}
