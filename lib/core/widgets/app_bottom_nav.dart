// lib/core/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';

enum AppTab { home, library, plans, timer, schools }

class AppBottomNav extends StatelessWidget {
  final AppTab current;
  final ValueChanged<AppTab> onChanged;

  const AppBottomNav({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(35, 86, 130, 1),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              for (final tab in AppTab.values)
                _NavItem(
                  assetPath: _assetFor(tab),
                  label: _labelFor(tab),
                  selected: current == tab,
                  onTap: () => onChanged(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _assetFor(AppTab t) => switch (t) {
        AppTab.home => 'assets/icons/home.png',
        AppTab.library => 'assets/icons/library.png',
        AppTab.plans => 'assets/icons/plans.png',
        AppTab.timer => 'assets/icons/timer.png',
        AppTab.schools => 'assets/icons/schools.png',
      };

  String _labelFor(AppTab t) => switch (t) {
        AppTab.home => 'Home',
        AppTab.library => 'Library',
        AppTab.plans => 'Plans',
        AppTab.timer => 'Timer',
        AppTab.schools => 'Schools',

      };
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.assetPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20;
    final Color iconColor = Colors.white.withOpacity(selected ? 1.0 : 0.75);
    final Color textColor = iconColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Центрована іконка + текст
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    assetPath,
                    width: iconSize,
                    height: iconSize,
                    // Якщо твої ассети вже білі — можеш прибрати color:
                    color: iconColor,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
            // Індикатор під активним табом
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: selected ? 46 : 0,
                height: 6,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
