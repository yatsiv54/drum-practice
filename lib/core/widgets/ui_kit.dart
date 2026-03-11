import 'package:flutter/material.dart';
import '../../core/colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: padding,
      child: child,
    );
  }
}

class DurationPill extends StatelessWidget {
  final String text;
  const DurationPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: CustomColors.greenForButton,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4),
          Text(
            '🕒 $text',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        // ignore: deprecated_member_use
        fillColor: Colors.white.withOpacity(.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
