import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as Words;

class WordProvider extends ChangeNotifier {
  List<String> wordList = [];
  ValueNotifier<bool> wrongAnswer = ValueNotifier(false);
  bool _hasQuizStarted = false;
  bool get hasQuizStarted => _hasQuizStarted;
  final _maxLevel = 3;
  final _maxWordPerLevel = 10;
  int _currentLevel = 1;
  int get currentLevel => _currentLevel;
  int _currentIndex = 0;
  int _attemptLeft = 2;
  int get attempLeft => _attemptLeft;
  String displayWord = '';
  String track = '';

  bool get shouldLevelUp => _currentLevel < _maxLevel;

  startQuiz() {
    _hasQuizStarted = true;
    wrongAnswer.value = false;
    _generateList(length: _currentLevel + 2);
    setTrack();
    setWord();
    print(wordList);
    notifyListeners();
  }

  resetQuiz() {
    _hasQuizStarted = false;
    _currentLevel = 1;
    _currentIndex = 0;
    _attemptLeft = currentLevel + 1;
    wrongAnswer.value = false;
    wordList = [];
    notifyListeners();
  }

  _generateList({required int length}) {
    final tempList =
    Words.nouns.where((element) => element.length == length).toList();
    tempList.shuffle();
    wordList = tempList.sublist(0, tempList.length > _maxWordPerLevel ? _maxWordPerLevel : tempList.length - 1);
  }

  String _shuffleWord(String word) {
    String shuffledWord = '';
    List<String> tempList = word.split('');
    tempList.shuffle();
    shuffledWord = tempList.join('');
    if(shuffledWord == word) {
      return _shuffleWord(word);
    }
    return shuffledWord;
  }

  setWord() {
    displayWord = _shuffleWord(wordList[_currentIndex]).toUpperCase();
  }

  setTrack() {
    track = '${_currentIndex + 1} of ${wordList.length}';
  }

  bool get shouldGetNextWord => _currentIndex < _maxWordPerLevel - 1;

  bool get doesAnyAttemptLeft => _attemptLeft > 0;

  bool isInputCorrect(String input) => input == wordList[_currentIndex].toLowerCase();

  nextWord() {
    _currentIndex++;
    setTrack();
    setWord();
    notifyListeners();
  }

  goToNextLevel() {
    wordList = [];
    _currentLevel++;
    _attemptLeft = _currentLevel + 1;
    _currentIndex = 0;
    _generateList(length: _currentLevel + 2);
    setTrack();
    setWord();
    //print(wordList);
    notifyListeners();
  }

  decreaseAttempt() {
    _attemptLeft--;
    notifyListeners();
  }
}
