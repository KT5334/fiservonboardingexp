import 'package:fiservonboardingexp/themes/theme_provider.dart';
import 'package:fiservonboardingexp/util/constants.dart';
import 'package:fiservonboardingexp/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar_overlay.dart';
import '../widgets/faq_list.dart';
import 'package:google_fonts/google_fonts.dart';

// Handles the UI for FAQ page
class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeData selectedTheme = themeProvider.currentTheme;

    return Scaffold(
      appBar: AppBarOverlay(),
      bottomNavigationBar: CustomNavBar(),
      backgroundColor: selectedTheme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: GoogleFonts.quicksand(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: selectedTheme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Gets the Questions and Answers here (Dropdown widget thing)
              Expanded(
                child: FaqList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
