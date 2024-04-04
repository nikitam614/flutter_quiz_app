

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/models/questions_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:quiz_application_tut_from_scracth/views/admin/score_page.dart';


class QuestionController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double>get animation=>_animation;
  late PageController _pageController;
  PageController get pageController=>_pageController;
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAns => _selectedAns;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  List<Question> _questions = [];

  List<Question> get questions => _questions;
  final TextEditingController questionControllerText=TextEditingController();
  final List<TextEditingController>optionControllers=List.generate(4,(index)=>TextEditingController());
  final TextEditingController correctAnswerController=TextEditingController();
  final TextEditingController quizCategory=TextEditingController();

  Future<void> saveQuestionToSharedPrefrences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];

    // Convert the question to JSON and add it to the questions list
    questions.add(jsonEncode(question.toJson()));

    // Save the updated questions list into SharedPreferences
    await prefs.setStringList("questions", questions);
  }
  // Admin Dashboard
  Future<void> deleteCategory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];

    categories.removeAt(index);
    subtitles.removeAt(index);

    await prefs.setStringList(_categoryKey, categories);
    await prefs.setStringList(_subtitleKey, subtitles);

    // Reload the categories from shared preferences
    loadQuestionCategoryFromSharedPrefrences();
  }

  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void savedQuestionCategoryToSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(categoryTitleController.text);
    savedSubtitle.add(categorySubtitleController.text);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);

    categorySubtitleController.clear();
    categoryTitleController.clear();
    Get.snackbar("saved", "Category Created Successfully");
  }

  void loadQuestionCategoryFromSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];

    savedCategories.assignAll(categories);
    savedSubtitle.assignAll(subtitles);
    update();
  }

  void loadQuestionsFromSharedPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getStringList("questions") ?? [];
    _questions = questionsJson.map((json) => Question.fromJson(jsonDecode(json))).toList();
    update();
  }

  List<Question> getQuestionsByCategory(String category) {
    return _questions.where((question) => question.category == category).toList();
  }
  void checkAnswer(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;
    if (_correctAns == _selectedAns) _numOfCorrectAns++;
    _animationController.stop();
    Future.delayed(const Duration(seconds: 3),(){
      nextQuestion();
    });

  }

  void nextQuestion() async {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(duration: const Duration(microseconds: 250),
          curve:Curves.ease);
    }else{
      // Get.to(const ScorePage());
    }
  }
  void updateTheQnNum(int index){
    _questionNumber.value=index+1;
    update();
  }


  @override
  void onInit() {
    _animationController=AnimationController(vsync: this,duration:const Duration(seconds:60));
    _animation=Tween<double>(begin: 0,end:1).animate(_animationController)..addListener(() { });
    update();
    _animationController.forward().whenComplete(nextQuestion);
    loadQuestionCategoryFromSharedPrefrences();
    loadQuestionsFromSharedPrefrences();
    _pageController = PageController();
    super.onInit();
  }
}
