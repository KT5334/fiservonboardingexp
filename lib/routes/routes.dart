import 'package:fiservonboardingexp/screens/faq_page.dart';
import 'package:fiservonboardingexp/screens/home_page.dart';
import 'package:fiservonboardingexp/screens/login_page.dart';
import 'package:fiservonboardingexp/screens/main_screen.dart';
import 'package:fiservonboardingexp/screens/manager/manager_view.dart';
import 'package:fiservonboardingexp/screens/profile_page.dart';
import 'package:fiservonboardingexp/screens/settings_page.dart';
import 'package:fiservonboardingexp/widgets/check_user.dart';
import 'package:get/get.dart';

import '../screens/help_page.dart';
import '../screens/teaser pages/teaser.dart';

class FiservAppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: "/",
          page: () => CheckUser(),
        ),
        GetPage(
          name: "/login",
          page: () => LoginPage(),
        ),
        GetPage(
          name: "/teaser",
          page: () => const TeaserScreen(),
        ),
        GetPage(
          name: "/help",
          page: () => const HelpPage(),
        ),
        GetPage(
          name: "/home",
          page: () => const HomePage(),
        ),
        GetPage(
          name: "/manager",
          page: () => ManagerView(),
        ),
        GetPage(
          name: "/mainScreen",
          page: () => const MainScreen(),
        ),
        GetPage(
          name: "/faq",
          page: () => FaqPage(),
        ),
        GetPage(
          name: "/settings",
          page: () => const SettingsPage(),
        ),
        GetPage(
          name: "/profile",
          page: () => const ProfilePage(),
        ),

        // GetPage(
        //     name: QuizQuestionScreen.routeName,
        //     page: () => const QuizQuestionScreen(),
        //     binding: BindingsBuilder(() {
        //       Get.put(QuestionController());
        //     })),
      ];
}