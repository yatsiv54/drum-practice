// lib/features/presentation/splash/view/splash_screen.dart
import 'dart:async';
import 'package:drum_practice_app/core/widgets/spinner_loader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.nextRoute = '/home'});
  final String nextRoute;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _kWelcomeShown = 'welcome_shown';

  @override
  void initState() {
    super.initState();
    _decideNext();
  }

  Future<void> _decideNext() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_kWelcomeShown) ?? false;

    // Мінімум 2 секунди сплеша
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    context.go(seen ? widget.nextRoute : '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: _Body()),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
        SizedBox(height: 22),
        GradientCupertinoSpinner(
          radius: 12,
          lineLength: 12,
          lineWidth: 4,
          ticks: 8,
          light: Color(0xFFE7FFBF),
          dark: Color(0xFF80AB3A),
          minScale: .32,
          minOpacity: .22,
        ),
      ],
    );
  }
}
