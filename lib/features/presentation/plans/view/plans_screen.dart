import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';
import 'package:drum_practice_app/features/presentation/plans/cubit/plans_list_cubit.dart';
import 'package:drum_practice_app/features/presentation/plans/cubit/plans_list_state.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/core/di.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  Future<int> totalMinutesAsync(Plan p) async {
    final exRepo = getIt<ExerciseRepository>();
    int sum = 0;

    for (final item in p.items) {
      final ex = await exRepo.getById(item.exerciseId);
      sum += (ex?.minutes ?? item.minutes).round();
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            Text(
              'Training Plans',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Expanded(
              child: BlocBuilder<PlansListCubit, PlansListState>(
                builder: (ctx, state) => state.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (m) => Center(
                    child: Text(m, style: const TextStyle(color: Colors.white)),
                  ),
                  loaded: (plans) => ListView.separated(
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = plans[i];
                      final minutes = p.items.fold<int>(
                        0,
                        (s, e) => s + e.minutes,
                      );
                      return _PlanCard(
                        title: p.title,
                        minutes: minutes,
                        count: p.items.length,
                        onTap: () => context.push('/plans/${p.id}'),
                      );
                    },
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.fromLTRB(
                8,
                8,
                8,
                MediaQuery.of(context).padding.bottom + 0,
              ),
              child: CustomButton(
                height: 75,
                text: 'New Plan',
                onPressed: () async {
                  final changed = await context.push<bool>('/plans/create');
                  if (changed == true && context.mounted) {
                    context.read<PlansListCubit>().loadOnce();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final int minutes;
  final int count;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.minutes,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MinutesPill(text: '🕒 $minutes minutes'),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Exercises: $count',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.arrow_forward, color: Colors.black87, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinutesPill extends StatelessWidget {
  final String text;
  const _MinutesPill({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: CustomColors.greenForButton,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [SizedBox(width: 4)],
    ).copyWithText(text),
  );
}

extension on Row {
  Row copyWithText(String t) => Row(
    mainAxisSize: mainAxisSize,
    children: [
      ...children.take(2),
      Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );
}
