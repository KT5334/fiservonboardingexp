import 'package:fiservonboardingexp/util/constants.dart';
import 'package:fiservonboardingexp/themes/quiz%20themes/ui_parameters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/quiz widgets/app_icon_text.dart';
import '../../../../controllers/quiz controllers/quiz_controller.dart';
import '../../../../model/quiz_model.dart';

class QuestionCard extends GetView<QuizController> {
  final QuizModel model;

  const QuestionCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = getSelectedTheme(context);
    const double padding = 10.0;
    return Container(
      decoration: BoxDecoration(
          borderRadius: UIParameters.cardBorderRadius, color: darkTileColor),
      child: InkWell(
        onTap: () {
          controller.navigateToQuestions(quiz: model);
        },
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: SizedBox(
                        height: Get.width * 0.15,
                        width: Get.width * 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.title,
                            style: TextStyle(
                                color: selectedTheme.colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                          child: Text(
                            model.id,
                            style: TextStyle(
                                color: selectedTheme.colorScheme.primary),
                          ),
                        ),
                        Row(children: [
                          AppIconText(
                            icon: Icon(
                              Icons.help_outline_sharp,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                            ),
                            text: Text(
                              '${model.questionCount} questions',
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 15),
                          AppIconText(
                            icon: Icon(
                              Icons.timer,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                            ),
                            text: Text(
                              model.timeConverterTxt(),
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                          )
                        ])
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: -padding,
                  right: -padding,
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 43, 42, 42),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(cardBorderPadding),
                              bottomRight: Radius.circular(cardBorderPadding))),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: fiservColor),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
