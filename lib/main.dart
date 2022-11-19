import 'package:flutter/material.dart';
import 'package:word_puzzle_batch8/word_provider.dart';

import 'word_puzzle_screen.dart';
import 'package:provider/provider.dart';

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

