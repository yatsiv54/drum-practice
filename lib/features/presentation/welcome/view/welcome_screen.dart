import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: CustomColors.primaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Text('Welcome to', style: textTheme.displayLarge),
                  Text('Drum Journal!', style: textTheme.displayLarge),
                  const SizedBox(height: 12),
                  Text(
                    'Your personal assistant for\neffective drum practice.',
                    textAlign: TextAlign.center,
                    style: textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/drum.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 45),
          child: CustomButton(
            height: 70,
            text: "Let’s Start",
            
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('welcome_shown', true);
              if (!context.mounted) return;
              context.go('/home');
            },
          ),
        ),
      ),
    );
  }
}
