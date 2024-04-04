import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/body.dart';


class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key,required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuestionController questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: questionController.nextQuestion,
            child: const Text("Skip"),
          ), // TextButton
        ], // actions
      ), // AppBar
      body: Body(),
    ); // Scaffold
  }
}
