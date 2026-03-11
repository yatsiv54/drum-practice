import 'package:drum_practice_app/core/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CustomColors.greenForButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ), 
          ),
        ),
        child: Text(text, style: textTheme.bodyMedium),
      ),
    );
  }
}
