import 'package:drum_practice_app/core/colors.dart';
import 'package:flutter/material.dart';

class TagRow extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;
  const TagRow({required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: CustomColors.customLightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
