import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import màn hình bạn vừa tạo
import 'screens/shipper_screen.dart';

void main() {
  runApp(const SmartWashApp());
}

class SmartWashApp extends StatelessWidget {
  const SmartWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wash',
      debugShowCheckedModeBanner: false, // Ẩn chữ DEBUG góc phải
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9F1239),
        ), // Tone đỏ chủ đạo
        useMaterial3: true,
      ),
     
       home: const SplashScreen(),// Đặt Splash Screen làm màn hình khởi động
    );
  }
}
