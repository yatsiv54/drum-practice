
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:drum_practice_app/features/domain/entities/exercise.dart';

class AttachmentStore {
  static Future<List<MediaAttachment>> persistPickedFiles({
    required List<PlatformFile> files,
  }) async {
    final out = <MediaAttachment>[];
    for (final f in files) {
      final ext = p.extension(f.name.isNotEmpty ? f.name : (f.path ?? '')).toLowerCase();
      final mime = lookupMimeType(f.name, headerBytes: f.bytes) ?? '';

      final isImage = mime.startsWith('image/');
      final isPdf   = mime == 'application/pdf' || ext == '.pdf';
      final isVideo = mime.startsWith('video/');

      final saved = await _persistOne(f);
      if (saved == null) continue;

      if (isImage) {
        out.add(MediaAttachment.image(
          path: saved.path,
          webBase64: saved.webBase64,
          name: f.name,
          size: f.size,
        ));
      } else if (isPdf) {
        out.add(MediaAttachment.pdf(
          path: saved.path,
          webBase64: saved.webBase64,
          name: f.name,
          size: f.size,
        ));
      } else if (isVideo) {
        out.add(MediaAttachment.video(
          path: saved.path,
          webBase64: saved.webBase64,
          name: f.name,
          size: f.size,
        ));
      } else {

      }
    }
    return out;
  }

  static Future<_Saved> _persistOne(PlatformFile f) async {
    if (kIsWeb) {
      if (f.bytes == null) return _Saved('', null);
      final b64 = base64Encode(f.bytes!);
      return _Saved('', b64);
    }

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'attachments'));
    if (!await dir.exists()) await dir.create(recursive: true);

    final ext = p.extension(f.name.isNotEmpty ? f.name : (f.path ?? ''));
    final id  = const Uuid().v4();
    final target = p.join(dir.path, '$id$ext');

    if (f.path != null) {
      await File(f.path!).copy(target);
    } else if (f.bytes != null) {
      await File(target).writeAsBytes(f.bytes!);
    } else {
      return _Saved('', null);
    }
    return _Saved(target, null);
  }
}

class _Saved {
  final String path;
  final String? webBase64;
  _Saved(this.path, this.webBase64);
}
