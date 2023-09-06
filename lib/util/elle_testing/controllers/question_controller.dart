import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiservonboardingexp/util/elle_testing/firebase_ref/loading_status.dart';
import 'package:fiservonboardingexp/util/elle_testing/models/quiz_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../firebase_ref/firebase_ref.dart';

class QuestionController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  late QuizModel quizModel;

  final allQuizQuestions = <Question>[];
  Rxn<Question> currentQuestion = Rxn<Question>();

  @override
  void onReady() {
    final quizQuestion = Get.arguments as QuizModel;
    // test to see if it can pull the question document id from the collection
    // print(quizQuestion.id);
    loadData(quizQuestion);
    super.onReady();
  }

  // reads data from a collection
  Future<void> loadData(QuizModel quizQuestion) async {
    quizModel = quizQuestion;
    loadingStatus.value = LoadingStatus.loading;

    try {
      // Query the 'questions' collection for documents
      final QuerySnapshot<Map<String, dynamic>> questionQuery =
          await quizref.doc(quizQuestion.id).collection("questions").get();

      // Takes a document snapshot and converts into a 'Question' object
      final questions = questionQuery.docs
          .map((snapshot) => Question.fromSnapshot(snapshot))
          .toList();
      // Updates the 'quizQuestion' object with the list of questions (documents) obtained from Firestore
      quizQuestion.questions = questions;

      //  iterates through each 'Question' object within the 'quizQuestion' object
      for (Question question in quizQuestion.questions!) {
        // queries Firestore for a collection of options associated with the current 'Question'
        final QuerySnapshot<Map<String, dynamic>> optionQuery = await quizref
            .doc(quizQuestion.id)
            .collection("questions")
            .doc(question.id)
            .collection("options")
            .get();

        // maps the retrieved documents in optionQuery to a list of Option objects named 'options'.
        final options = optionQuery.docs
            .map((option) => Option.fromSnapshot(option))
            .toList();

        // Assigns 'options' list to the question.options property
        question.options = options;

        // checks if quizQuestion.questions is not null and not empty before assigning them to 'allQuizQuestions' list
        if (quizQuestion.questions != null &&
            quizQuestion.questions!.isNotEmpty) {
          allQuizQuestions.assignAll(quizQuestion.questions!);
          //print(quizQuestion.questions![0]);
          loadingStatus.value = LoadingStatus.completed;
        } else {
          loadingStatus.value = LoadingStatus.error;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
