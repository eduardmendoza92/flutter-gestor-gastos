import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MonolithicApp());
}

class MonolithicApp extends StatelessWidget {
  const MonolithicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastos - Monolitico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
