import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/option.dart'; // Import Options widget
import '../../models/questions_model.dart';
import '../../utils/constants.dart';

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key,required this.question});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());

    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column( // Use ListView instead of Column
         // Shrink-wrap to fit the content size
        children: [
          Text(
            question.questions,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kBlackColor),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            question.options.length,
                (index) => Options(
              index: index,
              text: question.options[index],
              press: () => questionController.checkAnswer(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
