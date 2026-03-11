// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get id; String get title; String get description; int get minutes; List<String> get tags; List<MediaAttachment> get attachments; DateTime get createdAt;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,minutes,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(attachments),createdAt);

@override
String toString() {
  return 'Exercise(id: $id, title: $title, description: $description, minutes: $minutes, tags: $tags, attachments: $attachments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, int minutes, List<String> tags, List<MediaAttachment> attachments, DateTime createdAt
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? minutes = null,Object? tags = null,Object? attachments = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MediaAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise implements Exercise {
  const _Exercise({required this.id, required this.title, required this.description, required this.minutes, final  List<String> tags = const <String>[], final  List<MediaAttachment> attachments = const <MediaAttachment>[], required this.createdAt}): _tags = tags,_attachments = attachments;
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  int minutes;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<MediaAttachment> _attachments;
@override@JsonKey() List<MediaAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  DateTime createdAt;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,minutes,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_attachments),createdAt);

@override
String toString() {
  return 'Exercise(id: $id, title: $title, description: $description, minutes: $minutes, tags: $tags, attachments: $attachments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, int minutes, List<String> tags, List<MediaAttachment> attachments, DateTime createdAt
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? minutes = null,Object? tags = null,Object? attachments = null,Object? createdAt = null,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MediaAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

MediaAttachment _$MediaAttachmentFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'image':
          return ImageAttachment.fromJson(
            json
          );
                case 'pdf':
          return PdfAttachment.fromJson(
            json
          );
                case 'video':
          return VideoAttachment.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'MediaAttachment',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$MediaAttachment {

 String get path;// локальний шлях (mobile/desktop)
 String? get webBase64;// для Web
 String? get name; int? get size;
/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAttachmentCopyWith<MediaAttachment> get copyWith => _$MediaAttachmentCopyWithImpl<MediaAttachment>(this as MediaAttachment, _$identity);

  /// Serializes this MediaAttachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAttachment&&(identical(other.path, path) || other.path == path)&&(identical(other.webBase64, webBase64) || other.webBase64 == webBase64)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,webBase64,name,size);

@override
String toString() {
  return 'MediaAttachment(path: $path, webBase64: $webBase64, name: $name, size: $size)';
}


}

/// @nodoc
abstract mixin class $MediaAttachmentCopyWith<$Res>  {
  factory $MediaAttachmentCopyWith(MediaAttachment value, $Res Function(MediaAttachment) _then) = _$MediaAttachmentCopyWithImpl;
@useResult
$Res call({
 String path, String? webBase64, String? name, int? size
});




}
/// @nodoc
class _$MediaAttachmentCopyWithImpl<$Res>
    implements $MediaAttachmentCopyWith<$Res> {
  _$MediaAttachmentCopyWithImpl(this._self, this._then);

  final MediaAttachment _self;
  final $Res Function(MediaAttachment) _then;

/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? webBase64 = freezed,Object? name = freezed,Object? size = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,webBase64: freezed == webBase64 ? _self.webBase64 : webBase64 // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAttachment].
extension MediaAttachmentPatterns on MediaAttachment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImageAttachment value)?  image,TResult Function( PdfAttachment value)?  pdf,TResult Function( VideoAttachment value)?  video,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImageAttachment() when image != null:
return image(_that);case PdfAttachment() when pdf != null:
return pdf(_that);case VideoAttachment() when video != null:
return video(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImageAttachment value)  image,required TResult Function( PdfAttachment value)  pdf,required TResult Function( VideoAttachment value)  video,}){
final _that = this;
switch (_that) {
case ImageAttachment():
return image(_that);case PdfAttachment():
return pdf(_that);case VideoAttachment():
return video(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImageAttachment value)?  image,TResult? Function( PdfAttachment value)?  pdf,TResult? Function( VideoAttachment value)?  video,}){
final _that = this;
switch (_that) {
case ImageAttachment() when image != null:
return image(_that);case PdfAttachment() when pdf != null:
return pdf(_that);case VideoAttachment() when video != null:
return video(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String path,  String? webBase64,  String? name,  int? size)?  image,TResult Function( String path,  String? webBase64,  String? name,  int? size)?  pdf,TResult Function( String path,  String? webBase64,  String? name,  int? size)?  video,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImageAttachment() when image != null:
return image(_that.path,_that.webBase64,_that.name,_that.size);case PdfAttachment() when pdf != null:
return pdf(_that.path,_that.webBase64,_that.name,_that.size);case VideoAttachment() when video != null:
return video(_that.path,_that.webBase64,_that.name,_that.size);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String path,  String? webBase64,  String? name,  int? size)  image,required TResult Function( String path,  String? webBase64,  String? name,  int? size)  pdf,required TResult Function( String path,  String? webBase64,  String? name,  int? size)  video,}) {final _that = this;
switch (_that) {
case ImageAttachment():
return image(_that.path,_that.webBase64,_that.name,_that.size);case PdfAttachment():
return pdf(_that.path,_that.webBase64,_that.name,_that.size);case VideoAttachment():
return video(_that.path,_that.webBase64,_that.name,_that.size);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String path,  String? webBase64,  String? name,  int? size)?  image,TResult? Function( String path,  String? webBase64,  String? name,  int? size)?  pdf,TResult? Function( String path,  String? webBase64,  String? name,  int? size)?  video,}) {final _that = this;
switch (_that) {
case ImageAttachment() when image != null:
return image(_that.path,_that.webBase64,_that.name,_that.size);case PdfAttachment() when pdf != null:
return pdf(_that.path,_that.webBase64,_that.name,_that.size);case VideoAttachment() when video != null:
return video(_that.path,_that.webBase64,_that.name,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ImageAttachment implements MediaAttachment {
  const ImageAttachment({required this.path, this.webBase64, this.name, this.size, final  String? $type}): $type = $type ?? 'image';
  factory ImageAttachment.fromJson(Map<String, dynamic> json) => _$ImageAttachmentFromJson(json);

@override final  String path;
// локальний шлях (mobile/desktop)
@override final  String? webBase64;
// для Web
@override final  String? name;
@override final  int? size;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageAttachmentCopyWith<ImageAttachment> get copyWith => _$ImageAttachmentCopyWithImpl<ImageAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageAttachment&&(identical(other.path, path) || other.path == path)&&(identical(other.webBase64, webBase64) || other.webBase64 == webBase64)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,webBase64,name,size);

@override
String toString() {
  return 'MediaAttachment.image(path: $path, webBase64: $webBase64, name: $name, size: $size)';
}


}

/// @nodoc
abstract mixin class $ImageAttachmentCopyWith<$Res> implements $MediaAttachmentCopyWith<$Res> {
  factory $ImageAttachmentCopyWith(ImageAttachment value, $Res Function(ImageAttachment) _then) = _$ImageAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String path, String? webBase64, String? name, int? size
});




}
/// @nodoc
class _$ImageAttachmentCopyWithImpl<$Res>
    implements $ImageAttachmentCopyWith<$Res> {
  _$ImageAttachmentCopyWithImpl(this._self, this._then);

  final ImageAttachment _self;
  final $Res Function(ImageAttachment) _then;

/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? webBase64 = freezed,Object? name = freezed,Object? size = freezed,}) {
  return _then(ImageAttachment(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,webBase64: freezed == webBase64 ? _self.webBase64 : webBase64 // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PdfAttachment implements MediaAttachment {
  const PdfAttachment({required this.path, this.webBase64, this.name, this.size, final  String? $type}): $type = $type ?? 'pdf';
  factory PdfAttachment.fromJson(Map<String, dynamic> json) => _$PdfAttachmentFromJson(json);

@override final  String path;
@override final  String? webBase64;
@override final  String? name;
@override final  int? size;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdfAttachmentCopyWith<PdfAttachment> get copyWith => _$PdfAttachmentCopyWithImpl<PdfAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PdfAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdfAttachment&&(identical(other.path, path) || other.path == path)&&(identical(other.webBase64, webBase64) || other.webBase64 == webBase64)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,webBase64,name,size);

@override
String toString() {
  return 'MediaAttachment.pdf(path: $path, webBase64: $webBase64, name: $name, size: $size)';
}


}

/// @nodoc
abstract mixin class $PdfAttachmentCopyWith<$Res> implements $MediaAttachmentCopyWith<$Res> {
  factory $PdfAttachmentCopyWith(PdfAttachment value, $Res Function(PdfAttachment) _then) = _$PdfAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String path, String? webBase64, String? name, int? size
});




}
/// @nodoc
class _$PdfAttachmentCopyWithImpl<$Res>
    implements $PdfAttachmentCopyWith<$Res> {
  _$PdfAttachmentCopyWithImpl(this._self, this._then);

  final PdfAttachment _self;
  final $Res Function(PdfAttachment) _then;

/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? webBase64 = freezed,Object? name = freezed,Object? size = freezed,}) {
  return _then(PdfAttachment(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,webBase64: freezed == webBase64 ? _self.webBase64 : webBase64 // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class VideoAttachment implements MediaAttachment {
  const VideoAttachment({required this.path, this.webBase64, this.name, this.size, final  String? $type}): $type = $type ?? 'video';
  factory VideoAttachment.fromJson(Map<String, dynamic> json) => _$VideoAttachmentFromJson(json);

@override final  String path;
@override final  String? webBase64;
@override final  String? name;
@override final  int? size;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoAttachmentCopyWith<VideoAttachment> get copyWith => _$VideoAttachmentCopyWithImpl<VideoAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoAttachment&&(identical(other.path, path) || other.path == path)&&(identical(other.webBase64, webBase64) || other.webBase64 == webBase64)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,webBase64,name,size);

@override
String toString() {
  return 'MediaAttachment.video(path: $path, webBase64: $webBase64, name: $name, size: $size)';
}


}

/// @nodoc
abstract mixin class $VideoAttachmentCopyWith<$Res> implements $MediaAttachmentCopyWith<$Res> {
  factory $VideoAttachmentCopyWith(VideoAttachment value, $Res Function(VideoAttachment) _then) = _$VideoAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String path, String? webBase64, String? name, int? size
});




}
/// @nodoc
class _$VideoAttachmentCopyWithImpl<$Res>
    implements $VideoAttachmentCopyWith<$Res> {
  _$VideoAttachmentCopyWithImpl(this._self, this._then);

  final VideoAttachment _self;
  final $Res Function(VideoAttachment) _then;

/// Create a copy of MediaAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? webBase64 = freezed,Object? name = freezed,Object? size = freezed,}) {
  return _then(VideoAttachment(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,webBase64: freezed == webBase64 ? _self.webBase64 : webBase64 // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
