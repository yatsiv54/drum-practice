// lib/features/presentation/settings/view/settings_screen.dart
import 'package:drum_practice_app/core/di.dart';
import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _policyUrl =
      'https://example.com/privacy'; // ========================================EDIT

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 22),

          _SolidButton(
            text: 'Share App',
            color: CustomColors.greenForButton,
            onPressed: () async {
              await Share.share(
                'Check out Drum Journal! https://wikipedia.org/', // ========================================EDIT
              );
            },
          ),
          const SizedBox(height: 14),

          _OutlineButton(
            text: 'Rate App',
            borderColor: CustomColors.greenForButton,
            onPressed: () async {
              final review = InAppReview.instance;
              if (await review.isAvailable()) {
                await review.requestReview();
              } else {
                review.openStoreListing(
                  appStoreId: 'com.example.drum_practice_app',
                );
              }
            },
          ),
          const SizedBox(height: 14),

          _SolidButton(
            text: 'Privacy Policy',
            color: const Color(0xFF3B6E9A),
            onPressed: () async {
              final uri = Uri.parse(_policyUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 14),

          _GradientButton(
            text: 'Clear App Data',
            colors: const [
              Color(0xFFDC0004),
              Color(0xFFF93C3F),
              Color(0xFFDC0004),
            ],
            onPressed: () async {
              final ok =
                  await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: CustomColors.primaryBlue,
                      title: const Text(
                        'Are you sure?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      content: const Text(
                        'All exercises, plans and settings will be deleted.',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop(true),

                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
              if (!ok) return;

              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await Future.wait([getIt<ExerciseRepository>().deleteAll()]);
              await Future.wait([getIt<PlanRepository>().deleteAll()]);
              // ignore: use_build_context_synchronously
              context.go('/home');
            },
          ),

          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  const _SolidButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;
  const _OutlineButton({
    required this.text,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bg = CustomColors.primaryBlue;
    return SizedBox(
      height: 60,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.text,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
