// main.dart
// Entry point for the Errands Board application.

import 'package:flutter/material.dart';

import 'pages/errands_board_page.dart';

void main() {
  runApp(const ErrandsApp());
}

/// Root widget of the application.
/// Configures MaterialApp and the theme.
class ErrandsApp extends StatelessWidget {
  const ErrandsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Errands Board',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ErrandsBoardPage(),
    );
  }
}
