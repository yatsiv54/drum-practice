import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed:
          onPressed ??
          () => context.canPop() ? context.pop() : context.go('/library'),
      icon: Image.asset('assets/icons/arrow.png', scale: 2.1),
      label: const Text(
        'Back',
        style: TextStyle(
          color: Color.fromRGBO(163, 188, 213, 1),
          fontSize: 23,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: Colors.white,
      ),
    );
  }
}
