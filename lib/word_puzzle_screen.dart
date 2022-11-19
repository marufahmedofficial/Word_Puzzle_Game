import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_text_styles.dart';
import 'word_provider.dart';

class WordPuzzleScreen extends StatefulWidget {
  const WordPuzzleScreen({Key? key}) : super(key: key);

  @override
  State<WordPuzzleScreen> createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
  final txtController = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Word Puzzle'),
        actions: [
          Consumer<WordProvider>(
            builder: (context, provider, child) => provider.hasQuizStarted
                ? TextButton(
                    onPressed: () {
                      _quit(provider);
                    },
                    child: const Text('QUIT'),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) => provider.hasQuizStarted
            ? SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Level ${provider.currentLevel}',
                      style: levelTxtStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      provider.track,
                      style: trackTxtStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      provider.displayWord,
                      style: wordTxtStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      child: ValueListenableBuilder(
                        valueListenable: provider.wrongAnswer,
                        builder: (context, value, _) => TextField(
                          textAlign: TextAlign.center,
                          style: normalTxtStyle.copyWith(fontSize: 30),
                          focusNode: focusNode,
                          controller: txtController,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white54)),
                              labelStyle: normalTxtStyle,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: value ? Colors.red : Colors.green,
                              )),
                              floatingLabelStyle: const TextStyle(fontSize: 20),
                              labelText: value
                                  ? 'Wrong Answer'
                                  : 'Rearrange the above word'),
                        ),
                      ),
                    ),
                    Text(
                      'Attempts left: ${provider.attempLeft}',
                      style: normalTxtStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _next(provider);
                      },
                      child: const Text('NEXT'),
                    ),
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    provider.startQuiz();
                  },
                  child: const Text('START'),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  void _next(WordProvider provider) {
    final input = txtController.text;
    if (input.isEmpty) return;
    if (provider.isInputCorrect(input.toLowerCase())) {
      provider.wrongAnswer.value = false;
      txtController.clear();
      if (provider.shouldGetNextWord) {
        focusNode.requestFocus();
        provider.nextWord();
      } else if (provider.shouldLevelUp) {
        showStatusDialog(
          title: 'Level Up +1',
          body: 'Congratulations. You are going to the next level',
          onComplete: () {
            provider.goToNextLevel();
          },
        );
      } else {
        //player has completed all the levels. Show dialog, congratulate and reset
        showStatusDialog(
          title: 'Winner',
          body: 'Congratulations. You are the BOSS!',
          onComplete: () {
            provider.resetQuiz();
          },
        );
      }
    } else {
      //wrong answer, check if there any attempt left
      if (provider.doesAnyAttemptLeft) {
        provider.wrongAnswer.value = true;
        provider.decreaseAttempt();
      } else {
        //quiz lost, show dialog, then reset game
        txtController.clear();
        showStatusDialog(
          title: 'You Lost',
          body: 'You have lost the quiz. ',
          onComplete: () {
            provider.resetQuiz();
          },
        );
      }
    }
  }

  showStatusDialog(
      {required String title,
      required String body,
      Widget? cancel,
      required VoidCallback onComplete}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: [
                if (cancel != null) cancel,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onComplete();
                  },
                  child: const Text(
                    'YES',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
              ],
            ));
  }

  void _quit(WordProvider provider) {
    showStatusDialog(
      title: 'Quit',
      body: 'Press YES to quit this game.',
      cancel: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('CANCEL'),
      ),
      onComplete: () {
        provider.resetQuiz();
      },
    );
  }
}
