import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application_tut_from_scracth/controllers/question_controller.dart';
import 'admin_screen.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({Key? key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  final QuestionController questionController = Get.put(QuestionController());

  @override
  void initState(){
    questionController.loadQuestionCategoryFromSharedPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin DashBoard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap:(){
                    Get.to(AdminScreen
                      (quizCategory:controller.savedCategories[index]));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(controller.savedCategories[index]),
                  subtitle: Text(controller.savedSubtitle[index]),
                  trailing: IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, index); // Call delete confirmation dialog
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialogBox(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDialogBox() {
    Get.defaultDialog(
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: "Enter the category name"),
            controller: questionController
                .categoryTitleController, // Add this line
          ), // TextFormField
          TextFormField(
            decoration: InputDecoration(
                hintText: "Enter the category subtitle"),
            controller: questionController
                .categorySubtitleController, // Add this line
          ), // TextFormField
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        questionController.savedQuestionCategoryToSharedPrefrences();
        Get.back();
        // Update the UI by notifying the GetBuilder to rebuild
        questionController.update();
      },
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    Get.defaultDialog(
      title: "Delete Category",
      content: Text("Are you sure you want to delete this category?"),
      textConfirm: "Delete",
      textCancel: "Cancel",
      onConfirm: () {
        // Call the method to delete the category from shared preferences
        questionController.deleteCategory(index);

        // Close the dialog
        Get.back();
      },
    );
  }
}
