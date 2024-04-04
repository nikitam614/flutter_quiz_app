import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/question_card.dart';
import 'package:quiz_application_tut_from_scracth/views/admin/quiz_screen.dart';



import '../../utils/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.find();
    PageController pageController = questionController.pageController;
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          "assets/bg.svg",
          fit: BoxFit.fitWidth,
        ),
        SafeArea(
          child: Column(
            children: [
              Obx(
                    () => Text.rich(
                  TextSpan(
                    text: "Question ${questionController.questionNumber.value}",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: kScondaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "/${questionController.questions.length}",
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: kScondaryColor,
                        ),
                      ), // TextSpan
                    ], // children
                  ),
                ),
              ), // Obx
             const Divider(
                thickness: 1.5,
              ), // Divider
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: questionController.updateTheQnNum,
                  itemCount: questionController.questions.length,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    // Your item builder logic here
                    return QuestionCard(question: questionController.questions[index]); // Placeholder for now
                  },
                ),
              ), // Expanded
            ], // children
          ),
        ), // SafeArea
      ], // children
    ); // Stack
  }
}
