import 'dart:io' show File;

import 'package:dotted_border/dotted_border.dart' as db;
import 'package:drum_practice_app/core/files/attachment_store.dart';
import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/view/widgets/tag_picker.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/view/widgets/tag_row.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';

import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_state.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _minsC = TextEditingController();

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _minsC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ExerciseEditorCubit, ExerciseEditorState>(
        listenWhen: (p, c) => p.error != c.error || p.saved != c.saved,
        listener: (ctx, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.saved == true) Navigator.of(ctx).pop(true);
        },
        builder: (ctx, state) {
          if (_titleC.text != state.title) _titleC.text = state.title;
          if (_descC.text != state.description) _descC.text = state.description;
          final minsStr = state.minutes.toString();
          if (_minsC.text != minsStr) _minsC.text = minsStr;

          final isEdit = state.id != null;

          return AppLayout(
            leading: AppBackButton(),
            currentTab: AppTab.library,
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                _scrollBottomPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      isEdit ? 'Edit Exercise' : 'Create Exercise',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  _filledField(
                    controller: _titleC,
                    label: 'Title',
                    onChanged: context.read<ExerciseEditorCubit>().setTitle,
                  ),
                  const SizedBox(height: 12),
                  _filledField(
                    controller: _descC,
                    label: 'Description',

                    maxLines: 5,
                    onChanged: context
                        .read<ExerciseEditorCubit>()
                        .setDescription,
                  ),
                  const SizedBox(height: 12),

                  _DurationField(
                    controller: _minsC,
                    onChanged: (v) {
                      final m = int.tryParse(v) ?? 0;
                      context.read<ExerciseEditorCubit>().setMinutes(m);
                    },
                  ),
                  const SizedBox(height: 12),

                  _DashedBox(
                    height: 160,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _pickAttachment(context),
                      child: state.attachments.isEmpty
                          ? Center(
                              child: Text(
                                '+ Add image, PDF, video',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          : _AttachmentsGrid(
                              attachments: state.attachments,
                              onRemove: (i) => context
                                  .read<ExerciseEditorCubit>()
                                  .removeAttachment(i),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  if (state.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Column(
                      children: state.tags.map((tname) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TagRow(
                            text: tname,
                            onRemove: () => context
                                .read<ExerciseEditorCubit>()
                                .removeTag(tname),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  _DashedBox(
                    height: 56,
                    child: Container(
                      color: CustomColors.customLightBlue,
                      child: InkWell(
                        onTap: () => _openTagPicker(context),
                        child: Center(
                          child: Text(
                            '+ Add tags',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    height: 75,
                    text: isEdit ? 'Update' : 'Save',
                    onPressed: context.read<ExerciseEditorCubit>().save,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filledField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.displayMedium,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        filled: true,
        fillColor: CustomColors.customLightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Future<void> _pickAttachment(BuildContext context) async {
    final cubit = context.read<ExerciseEditorCubit>();

    await showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white),
              title: const Text(
                'Add image',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final res = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.image,
                  withData: kIsWeb,
                );
                if (res == null) return;
                final saved = await AttachmentStore.persistPickedFiles(
                  files: res.files,
                );
                for (final a in saved) {
                  cubit.addAttachment(a);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.white),
              title: const Text(
                'Add PDF',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final res = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: const ['pdf'],
                  withData: kIsWeb,
                );
                if (res == null) return;
                final saved = await AttachmentStore.persistPickedFiles(
                  files: res.files,
                );
                for (final a in saved) {
                  cubit.addAttachment(a);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.white),
              title: const Text(
                'Add video',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final res = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.video,
                  withData: kIsWeb,
                );
                if (res == null) return;
                final saved = await AttachmentStore.persistPickedFiles(
                  files: res.files,
                );
                for (final a in saved) {
                  cubit.addAttachment(a);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTagPicker(BuildContext context) async {
    final cubit = context.read<ExerciseEditorCubit>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CustomColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
        return TagPickerSheet(cubit: cubit);
      },
    );
  }
}

class _DashedBox extends StatelessWidget {
  final double height;
  final Widget child;
  const _DashedBox({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(27, 74, 114, 1),
      child: db.DottedBorder(
        color: Colors.white30,
        strokeWidth: 2,
        dashPattern: const [6, 6],
        borderType: db.BorderType.RRect,
        radius: const Radius.circular(5),

        child: SizedBox(height: height, child: child),
      ),
    );
  }
}

class _AttachmentsGrid extends StatelessWidget {
  final List<MediaAttachment> attachments;
  final void Function(int index) onRemove;

  const _AttachmentsGrid({required this.attachments, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: attachments.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 90,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, i) {
          final a = attachments[i];
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _Thumb(a),
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: InkWell(
                  onTap: () => onRemove(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final MediaAttachment a;
  const _Thumb(this.a);

  @override
  Widget build(BuildContext context) {
    return a.map(
      image: (img) {
        if (kIsWeb) {
          return Container(
            color: Colors.white10,
            child: const Icon(Icons.image, color: Colors.white70),
          );
        }
        return Image.file(File(img.path), fit: BoxFit.cover);
      },
      pdf: (pdf) => _iconThumb(Icons.picture_as_pdf),
      video: (v) => _iconThumb(Icons.videocam),
    );
  }

  Widget _iconThumb(IconData icon) => Container(
    color: Colors.white10,
    child: Center(child: Icon(icon, color: Colors.white70)),
  );
}

double _scrollBottomPadding(BuildContext context) {
  final mq = MediaQuery.of(context);
  const double navHeight = 72;
  final keyboard = mq.viewInsets.bottom;
  if (keyboard > 0) return keyboard + 24;
  return navHeight + mq.padding.bottom + 24;
}

class _DurationField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _DurationField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: Theme.of(context).textTheme.displayMedium,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Duration',
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        filled: true,
        fillColor: CustomColors.customLightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        suffixText: 'mins',
        suffixStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }
}
