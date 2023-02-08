import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_puzzle/word_provider.dart';
import 'word_puzzle_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WordProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const WordPuzzleScreen(),
    );
  }
}

