import 'dart:convert';
import 'dart:io' show File;

import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/core/widgets/ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';

import 'package:drum_practice_app/features/presentation/exercise_details/cubit/exercise_details_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_details/cubit/exercise_details_state.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/entities/tag_def.dart';
import 'package:share_plus/share_plus.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppLayout(
        leading: AppBackButton(),
        currentTab: AppTab.library,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: BlocBuilder<ExerciseDetailsCubit, ExerciseDetailsState>(
            builder: (context, state) => state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (m) => Center(
                child: Text(m, style: const TextStyle(color: Colors.white)),
              ),
              data: (ex, allTags) => _DetailsCard(ex: ex, allTags: allTags),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final Exercise ex;
  final List<TagDef> allTags;
  const _DetailsCard({required this.ex, required this.allTags});

  @override
  Widget build(BuildContext context) {
    final dateTxt =
        '${_monthName(ex.createdAt.month)} ${ex.createdAt.day}, ${ex.createdAt.year}';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 88),
      child: Column(
        children: [
          Text(
            'Exercise Details',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ex.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: -8,
                    children: ex.tags.map((name) {
                      final def = allTags.firstWhere(
                        (t) => t.name.toLowerCase() == name.toLowerCase(),
                        orElse: () => TagDef(
                          name: name,
                          color: const Color(0xFF9E9E9E).value,
                        ),
                      );
                      final bg = _soft(Color(def.color));
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          def.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (ex.tags.isNotEmpty) const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '📅Date: $dateTxt',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    DurationPill(text: '${ex.minutes} minutes'),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  ex.title,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 95, 95, 95),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ex.description,
                  style: const TextStyle(
                    height: 1.1,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 12),

                if (ex.attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: ex.attachments
                          .map(
                            (a) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _attachmentPreview(a),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Row(
                  children: [
                    _ActionCircle(
                      icon: 'edit',
                      color: Color.fromRGBO(233, 238, 242, 1),
                      onTap: () async {
                        final changed = await context.push<bool>(
                          '/library/exercises/${ex.id}/edit',
                          extra: ex,
                        );
                        if (changed == true && context.mounted) {
                          await context.read<ExerciseDetailsCubit>().load();
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _ActionCircle(
                      icon: 'delete',
                      color: Color.fromRGBO(220, 0, 4, 1),
                      onTap: () async {
                        final ok = await _confirmDelete(context);
                        if (ok == true) {
                          await context.read<ExerciseDetailsCubit>().delete();
                          if (context.mounted) context.pop(true);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _ActionCircle(
                      icon: 'share',
                      color: Color.fromRGBO(128, 171, 58, 1),
                      onTap: () => _shareExercise(context, ex),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _soft(Color base) {
    final h = HSLColor.fromColor(base);
    return h
        .withSaturation((h.saturation * 0.6).clamp(0, 1))
        .withLightness((h.lightness + 0.15).clamp(0.35, 0.85))
        .toColor();
  }
}

Widget _attachmentPreview(MediaAttachment a) {
  return a.map(
    image: (img) {
      if (kIsWeb && (img.webBase64 ?? '').isNotEmpty) {
        final bytes = base64Decode(img.webBase64!);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(bytes, height: 180, fit: BoxFit.cover),
        );
      }

      if (!kIsWeb && img.path.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(File(img.path), height: 180, fit: BoxFit.cover),
        );
      }

      return _fileTile(Icons.broken_image, img.name ?? 'image');
    },
    pdf: (pdf) => _fileTile(Icons.picture_as_pdf, pdf.name ?? 'document.pdf'),
    video: (v) => _fileTile(Icons.videocam, v.name ?? 'video'),
  );
}

Widget _fileTile(IconData icon, String label) {
  return Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
      ],
    ),
  );
}

class _ActionCircle extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionCircle({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(28),
    child: CircleAvatar(
      radius: 26,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: color,
        child: Image.asset('assets/icons/$icon.png', width: 24, height: 24),
      ),
    ),
  );
}

Future<bool> _confirmDelete(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: CustomColors.primaryBlue,
      title: const Text(
        'Delete exercise',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Are you sure you want to delete this exercise?',
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: Colors.white54)),
        ),
      ],
    ),
  );
  return res ?? false;
}

String _monthName(int m) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][m - 1];

Future<void> _shareExercise(BuildContext context, Exercise ex) async {
  try {
    final tags = ex.tags.isEmpty
        ? ''
        : '\nTags: ${ex.tags.map((t) => '#$t').join(' ')}';
    final text = StringBuffer()
      ..writeln(ex.title)
      ..writeln('${ex.minutes} minutes')
      ..writeln()
      ..writeln(ex.description)
      ..write(tags);

    final files = <XFile>[];

    for (final a in ex.attachments) {
      await a.map(
        image: (img) async {
          if (!kIsWeb && img.path.isNotEmpty) {
            files.add(
              XFile(
                img.path,
                name: img.name ?? 'image.jpg',
                mimeType: 'image/jpeg',
              ),
            );
          } else if (kIsWeb && (img.webBase64 ?? '').isNotEmpty) {
            final bytes = base64Decode(img.webBase64!);
            files.add(
              XFile.fromData(
                bytes,
                name: img.name ?? 'image.jpg',
                mimeType: 'image/jpeg',
              ),
            );
          }
        },
        pdf: (pdf) async {
          if (pdf.path.isNotEmpty) {
            files.add(
              XFile(
                pdf.path,
                name: pdf.name ?? 'document.pdf',
                mimeType: 'application/pdf',
              ),
            );
          }
        },
        video: (v) async {
          if (v.path.isNotEmpty) {
            files.add(
              XFile(v.path, name: v.name ?? 'video.mp4', mimeType: 'video/mp4'),
            );
          }
        },
      );

      if (files.length >= 4) break;
    }

    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: text.toString());
    } else {
      await Share.share(text.toString());
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Can’t share: $e')));
    }
  }
}
