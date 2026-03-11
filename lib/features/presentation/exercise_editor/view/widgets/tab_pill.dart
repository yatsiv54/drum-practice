import 'package:flutter/material.dart';

class TagPill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final VoidCallback onRemove;

  const TagPill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.onRemove,
    required ValueKey<String> key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: Icon(Icons.close, size: 16, color: fg),
          ),
        ],
      ),
    );
  }
}
