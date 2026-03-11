import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';

/// Роути для 5 вкладок (без Settings!)
extension AppTabRoute on AppTab {
  String get route => switch (this) {
        AppTab.home => '/home',
        AppTab.library => '/library',
        AppTab.plans => '/plans',
        AppTab.timer => '/timer',
        AppTab.schools => '/schools',
      };
}

/// Загальний лейаут екранів із заголовком, кнопкою ⚙ і нижнім баром.
/// Якщо передати [shell] + [settingsBranchIndex], перемикання табів і перехід
/// у Settings будуть без анімацій і зі збереженням стану.
class AppLayout extends StatelessWidget {
  final String? title;
  final Widget body;
  final AppTab currentTab;
  final List<Widget>? actions;
  final Widget? floating;
  final Widget? leading;

  /// Shell з `StatefulShellRoute.indexedStack`
  final StatefulNavigationShell? shell;

  /// Індекс гілки Settings у твоєму shell (НЕ таб; просто окрема гілка).
  /// Напр., якщо в router’і гілки: Home(0), Library(1), Plans(2), Timer(3),
  /// Schools(4), Settings(5) — тут передай 5.
  final int? settingsBranchIndex;

  const AppLayout({
    super.key,
    this.title,
    required this.body,
    required this.currentTab,
    this.actions,
    this.floating,
    this.leading,
    this.shell,
    this.settingsBranchIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.primaryBlue,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: CustomColors.primaryBlue,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: leading,
          leadingWidth: 110,
          title: title != null ? Text(title!) : null,
          actions: actions ??
              [
                // Іконка ⚙ з невеликим зсувом вниз-ліворуч
                Transform.translate(
                  offset: const Offset(-12, 3),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: IconButton(
                      onPressed: () {
                        // Якщо є shell і відомий індекс гілки Settings — йдемо туди без анімацій
                        if (shell != null && settingsBranchIndex != null) {
                          shell!.goBranch(settingsBranchIndex!,
                              initialLocation: false);
                        } else {
                         shell?.goBranch(settingsBranchIndex!, initialLocation: false);
                        }
                      },
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
        body: body,
        floatingActionButton: floating == null
            ? null
            : SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(width: double.infinity, child: floating),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: AppBottomNav(
          current: currentTab,
          onChanged: (tab) {
            if (tab == currentTab) return;
            final idx = AppTab.values.indexOf(tab);
            if (shell != null) {
              // Перемикаємо гілки в shell (без анімацій, без скидання стану)
              shell!.goBranch(idx, initialLocation: false);
            } else {
              // Фолбек
              context.go(tab.route);
            }
          },
        ),
      ),
    );
  }
}
