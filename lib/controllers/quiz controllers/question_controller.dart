import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiservonboardingexp/controllers/quiz%20controllers/auth_controller.dart';
import 'package:fiservonboardingexp/controllers/quiz%20controllers/extension_question_controller.dart';
import 'package:fiservonboardingexp/controllers/quiz%20controllers/quiz_controller.dart';
import 'package:fiservonboardingexp/widgets/quiz%20widgets/loading_status.dart';
import 'package:fiservonboardingexp/model/quiz_model.dart';
import 'package:fiservonboardingexp/screens/task%20pages/quiz%20screens/home_screen.dart';
import 'package:fiservonboardingexp/screens/task%20pages/quiz%20screens/quiz_outcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../firebase references/firebase_refs.dart';

class QuestionController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  late QuizModel quizModel;
  final allQuizQuestions = <Question>[];
  final questionIndex = 0.obs;
  bool get isFirstQuestion => questionIndex.value > 0; // false
  bool get isLastQuestion => questionIndex.value >= allQuizQuestions.length - 1;
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
          currentQuestion.value = quizQuestion.questions![0];
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

  void selectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    // points to the GetBuilder that has the id, answers_list
    update(['answers_list']);
  }

  void nextQuestion() {
    if (questionIndex.value >= allQuizQuestions.length - 1) {
      // return as there is no more questions
      return;
    } else {
      questionIndex.value++;
      currentQuestion.value = allQuizQuestions[questionIndex.value];
    }
  }

  void prevQuestion() {
    if (questionIndex.value <= 0) {
      // return as there is no more questions
      return;
    } else {
      questionIndex.value--;
      currentQuestion.value = allQuizQuestions[questionIndex.value];
    }
  }

  String get completedTest {
    final answered = allQuizQuestions
        .where((element) => element.selectedAnswer != null)
        .toList()
        .length;
    return 'You answered $answered out of ${allQuizQuestions.length} questions';
  }

  void complete() {
    Get.offAllNamed(QuizOutcomeScreen.routeName);
  }

  void tryAgain() {
    Get.find<QuizController>()
        .navigateToQuestions(quiz: quizModel, tryAgain: true);
  }

  void navigateToHome() {
    if (quizModel.expGained = false) {
      // add link to adding exp here
      Get.offNamedUntil(HomeScreen.routeName, (route) => false);
    } else {
      Get.offNamedUntil(HomeScreen.routeName, (route) => false);
    }
  }
}