import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';
import 'package:drum_practice_app/core/di.dart';

import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';

import '../../timer/cubit/timer_cubit.dart';
import '../../timer/cubit/timer_state.dart';

const double _kSaveBtnH = 75;
const double _kBottomNavH = 72;

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TimerCubit>()..watch(),
      child: SafeArea(
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (ctx, s) => s.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            idle: (items) => _PlansList(items: items),
            running: (plan, index, secsLeft, secsTotal, paused) {
              final exCount = plan.items.length;
              final cur = index + 1;
              final mm = (secsLeft ~/ 60).toString().padLeft(2, '0');
              final ss = (secsLeft % 60).toString().padLeft(2, '0');
              final elapsed = 1 - (secsLeft / (secsTotal == 0 ? 1 : secsTotal));

              return LayoutBuilder(
                builder: (context, _) {
                  final mq = MediaQuery.of(context);
                  final bottomScrollPadding =
                      _kSaveBtnH + _kBottomNavH + mq.padding.bottom + 40;

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          18,
                          16,
                          bottomScrollPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Timer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _BigTimer(
                              elapsed: elapsed,
                              timeText: '$mm:$ss',
                              paused: paused,
                              onPause: () => ctx.read<TimerCubit>().pause(),
                              onPlay: () => ctx.read<TimerCubit>().resume(),
                              onReset: () =>
                                  ctx.read<TimerCubit>().resetCurrent(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              plan.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            FutureBuilder(
                              future: getIt<ExerciseRepository>().getById(
                                plan.items[index].exerciseId,
                              ),
                              builder: (_, snap) {
                                final title =
                                    snap.data?.title ?? 'Exercise $cur';
                                return Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$cur/$exCount',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromRGBO(125, 167, 204, 1),
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            25,
                            8,
                            25,
                            MediaQuery.of(context).padding.bottom + 25,
                          ),
                          child: CustomButton(
                            height: _kSaveBtnH,
                            text: 'Save Plan',
                            onPressed: () async {
                              await ctx.read<TimerCubit>().saveAndExit();
                              if (!ctx.mounted) return;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlansList extends StatelessWidget {
  final List<TimerPlanItem> items;
  const _PlansList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Stack(
        children: [
          const Center(
            child: Text(
              'No plans yet',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: CustomButton(
                height: _kSaveBtnH,
                text: 'Create Plan',
                onPressed: () => context.go('/plans'),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final it = items[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<int>(
                      future: _totalMinutes(it.plan),
                      builder: (_, snap) {
                        final mins = snap.data ?? 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.greenForButton,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '🕒 $mins minutes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      it.plan.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(it.progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => context.read<TimerCubit>().start(it.plan.id),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int> _totalMinutes(Plan p) async {
    final exRepo = getIt<ExerciseRepository>();
    var sum = 0;
    for (final it in p.items) {
      final m =
          it.minutes ?? (await exRepo.getById(it.exerciseId))?.minutes ?? 0;
      sum += m.round();
    }
    return sum;
  }
}

class _BigTimer extends StatelessWidget {
  final double elapsed;
  final String timeText;
  final bool paused;
  final VoidCallback onPause;
  final VoidCallback onPlay;
  final VoidCallback onReset;

  const _BigTimer({
    required this.elapsed,
    required this.timeText,
    required this.paused,
    required this.onPause,
    required this.onPlay,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final ringSize = (screenW - 48).clamp(320.0, 380.0);
    const btnSize = 62.0;
    const gap = 12.0;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(ringSize),
            painter: _RingPainter(
              elapsed: elapsed,
              trackColor: const Color(0xFF556C80),
            ),
          ),
          Positioned.fill(
            top: -50,
            child: Center(
              child: Text(
                timeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _circleBtn('pause', onPause, size: btnSize),
                const SizedBox(width: gap),
                _circleBtn(
                  'play',
                  onPlay,
                  size: btnSize,
                  fill: const Color.fromRGBO(174, 213, 110, 1),
                ),
                const SizedBox(width: gap),
                _circleBtn('refresh', onReset, size: btnSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(
    String icon,
    VoidCallback onTap, {
    double size = 48,
    Color? fill,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fill ?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: icon == 'play'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 6),
                  Image.asset('assets/icons/$icon.png', scale: 15),
                ],
              )
            : Image.asset('assets/icons/$icon.png', scale: 15),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double elapsed;
  final Color trackColor;
  _RingPainter({required this.elapsed, required this.trackColor});
  static const double _stroke = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2 - _stroke / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -pi / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.butt
      ..color = trackColor;
    canvas.drawArc(rect, start, 2 * pi, false, track);

    final remainSweep = 2 * pi * (1 - elapsed.clamp(0.0, 1.0));
    if (remainSweep > 0) {
      final startRemain = start + 2 * pi * elapsed.clamp(0.0, 1.0);
      final ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.butt
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 127, 172, 55),
            Color.fromARGB(255, 201, 250, 123),
          ],
        ).createShader(rect);

      canvas.drawArc(rect, startRemain, remainSweep, false, ring);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.elapsed != elapsed || old.trackColor != trackColor;
}
