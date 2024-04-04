import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/models/questions_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;

  AdminScreen({Key? key, required this.quizCategory}) : super(key: key);

  final QuestionController questionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to $quizCategory"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: questionController.questionControllerText,
                decoration: InputDecoration(labelText: "Question"),
              ),
              for (var i = 0; i < 4; i++)
                TextFormField(
                  controller: questionController.optionControllers[i],
                  decoration: InputDecoration(labelText: "Option ${i + 1}"),
                ),
              TextFormField(
                controller: questionController.correctAnswerController,
                decoration: InputDecoration(labelText: "Correct Answer (0-3)"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (questionController.questionControllerText.text.isEmpty ||
                      questionController.optionControllers.any((option) => option.text.isEmpty) ||
                      questionController.correctAnswerController.text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else {
                    addQuestions(); // Call the method here
                  }
                },
                child: const Text("Add Questions"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addQuestions() async {
    // Collecting questions from the text controllers
    final String questionText = questionController.questionControllerText.text;
    final List<String> options = questionController.optionControllers.map((
        controller) => controller.text).toList();
    final int correctAnswer = int.tryParse(
        questionController.correctAnswerController.text) ?? 1;

    // Add your logic here to handle adding questions
    final Question newQuestion = Question(
      category: quizCategory,
      id: DateTime.now().microsecondsSinceEpoch,
      questions: questionText,
      options: options,
      answer: correctAnswer,
    );
    await questionController.saveQuestionToSharedPrefrences(newQuestion);
    Get.snackbar("Added", "Question Added");
    questionController.questionControllerText.clear();
    questionController.optionControllers.forEach((element) {
      element.clear();
    });
  }
}
