import 'package:flutter/material.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đây là bước quan trọng nhất để sửa lỗi 'NotInitializedError'
  await dotenv.load(fileName: ".env");
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
