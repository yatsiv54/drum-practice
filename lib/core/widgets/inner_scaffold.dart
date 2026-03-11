// lib/core/widgets/inner_page_scaffold.dart
import 'package:flutter/material.dart';
import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:go_router/go_router.dart';

class InnerPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const InnerPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBlue,
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: CustomColors.primaryBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const AppBackButton(),
        leadingWidth: 110,
        title: title != null ? Text(title!) : null,
        actions:
            actions ??
            [
              Transform.translate(
                offset: const Offset(-12, 3),
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: IconButton(
                    onPressed: () => context.go('/settings'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: CustomColors.gradientColors,
                      ).createShader(bounds),
                      child: Image.asset(
                        'assets/icons/custom_settings.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
      ),
      body: SafeArea(child: body),
    );
  }
}
