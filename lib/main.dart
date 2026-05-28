import 'package:flutter/material.dart';
import 'package:makequizz/screens/quizzes_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Make a quizz",
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(fontSize: 16)
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.grey,
          thickness: 1,
          indent: 30,
          endIndent: 30,
          space: 20, 
        ),
      ),
      home: const QuizzScreen(),
    );
  }
}




