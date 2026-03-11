import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/core/widgets/inner_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';
import 'package:drum_practice_app/core/di.dart';

import '../cubit/plan_details_cubit.dart';
import '../cubit/plan_details_state.dart';

class PlanDetailsScreen extends StatelessWidget {
  final String planId;
  const PlanDetailsScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlanDetailsCubit>()..load(planId),
      child: InnerPageScaffold(
        title: '',
        body: BlocBuilder<PlanDetailsCubit, PlanDetailsState>(
          builder: (ctx, state) => state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (m) => Center(
              child: Text(m, style: const TextStyle(color: Colors.white)),
            ),
            loaded: (id, title, totalMinutes, rows) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Details of the plan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),

                    _PlanCard(
                      title: title,
                      totalMinutes: totalMinutes,
                      rows: rows,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final int totalMinutes;
  final List<PlanRow> rows;

  const _PlanCard({
    required this.title,
    required this.totalMinutes,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MinutesPill(minutes: totalMinutes),
          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Exercises:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),

          for (int i = 0; i < rows.length; i++) ...[
            _ExerciseLine(index: i + 1, row: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _MinutesPill extends StatelessWidget {
  final int minutes;
  const _MinutesPill({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CustomColors.greenForButton,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🕒 $minutes minutes',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseLine extends StatelessWidget {
  final int index;
  final PlanRow row;

  const _ExerciseLine({required this.index, required this.row});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black54,
          height: 1.3,
        ),
        children: [
          TextSpan(
            text: '$index. ',
            style: const TextStyle(color: Color.fromRGBO(105, 105, 105, 1)),
          ),
          TextSpan(
            text: row.title,
            style: const TextStyle(color: Color.fromRGBO(105, 105, 105, 1)),
          ),
          const TextSpan(text: ' – '),
          TextSpan(text: '${row.minutes} min'),
        ],
      ),
    );
  }
}
