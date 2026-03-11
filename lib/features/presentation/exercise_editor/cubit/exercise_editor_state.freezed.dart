// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseEditorState {

 String? get id; String get title; String get description; int get minutes; List<String> get tags;// імена тегів на вправі
 List<MediaAttachment> get attachments; List<TagDef> get availableTags;// каталог збережених тегів
 String? get error; bool? get saved; bool? get loading;
/// Create a copy of ExerciseEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseEditorStateCopyWith<ExerciseEditorState> get copyWith => _$ExerciseEditorStateCopyWithImpl<ExerciseEditorState>(this as ExerciseEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseEditorState&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.availableTags, availableTags)&&(identical(other.error, error) || other.error == error)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,minutes,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(availableTags),error,saved,loading);

@override
String toString() {
  return 'ExerciseEditorState(id: $id, title: $title, description: $description, minutes: $minutes, tags: $tags, attachments: $attachments, availableTags: $availableTags, error: $error, saved: $saved, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $ExerciseEditorStateCopyWith<$Res>  {
  factory $ExerciseEditorStateCopyWith(ExerciseEditorState value, $Res Function(ExerciseEditorState) _then) = _$ExerciseEditorStateCopyWithImpl;
@useResult
$Res call({
 String? id, String title, String description, int minutes, List<String> tags, List<MediaAttachment> attachments, List<TagDef> availableTags, String? error, bool? saved, bool? loading
});




}
/// @nodoc
class _$ExerciseEditorStateCopyWithImpl<$Res>
    implements $ExerciseEditorStateCopyWith<$Res> {
  _$ExerciseEditorStateCopyWithImpl(this._self, this._then);

  final ExerciseEditorState _self;
  final $Res Function(ExerciseEditorState) _then;

/// Create a copy of ExerciseEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? description = null,Object? minutes = null,Object? tags = null,Object? attachments = null,Object? availableTags = null,Object? error = freezed,Object? saved = freezed,Object? loading = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MediaAttachment>,availableTags: null == availableTags ? _self.availableTags : availableTags // ignore: cast_nullable_to_non_nullable
as List<TagDef>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool?,loading: freezed == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseEditorState].
extension ExerciseEditorStatePatterns on ExerciseEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Editing value)?  editing,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Editing() when editing != null:
return editing(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Editing value)  editing,}){
final _that = this;
switch (_that) {
case _Editing():
return editing(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Editing value)?  editing,}){
final _that = this;
switch (_that) {
case _Editing() when editing != null:
return editing(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  List<TagDef> availableTags,  String? error,  bool? saved,  bool? loading)?  editing,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Editing() when editing != null:
return editing(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.availableTags,_that.error,_that.saved,_that.loading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  List<TagDef> availableTags,  String? error,  bool? saved,  bool? loading)  editing,}) {final _that = this;
switch (_that) {
case _Editing():
return editing(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.availableTags,_that.error,_that.saved,_that.loading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? id,  String title,  String description,  int minutes,  List<String> tags,  List<MediaAttachment> attachments,  List<TagDef> availableTags,  String? error,  bool? saved,  bool? loading)?  editing,}) {final _that = this;
switch (_that) {
case _Editing() when editing != null:
return editing(_that.id,_that.title,_that.description,_that.minutes,_that.tags,_that.attachments,_that.availableTags,_that.error,_that.saved,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class _Editing implements ExerciseEditorState {
  const _Editing({this.id, required this.title, required this.description, required this.minutes, final  List<String> tags = const <String>[], final  List<MediaAttachment> attachments = const <MediaAttachment>[], final  List<TagDef> availableTags = const <TagDef>[], this.error, this.saved, this.loading}): _tags = tags,_attachments = attachments,_availableTags = availableTags;
  

@override final  String? id;
@override final  String title;
@override final  String description;
@override final  int minutes;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

// імена тегів на вправі
 final  List<MediaAttachment> _attachments;
// імена тегів на вправі
@override@JsonKey() List<MediaAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

 final  List<TagDef> _availableTags;
@override@JsonKey() List<TagDef> get availableTags {
  if (_availableTags is EqualUnmodifiableListView) return _availableTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableTags);
}

// каталог збережених тегів
@override final  String? error;
@override final  bool? saved;
@override final  bool? loading;

/// Create a copy of ExerciseEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditingCopyWith<_Editing> get copyWith => __$EditingCopyWithImpl<_Editing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Editing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._availableTags, _availableTags)&&(identical(other.error, error) || other.error == error)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,minutes,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_availableTags),error,saved,loading);

@override
String toString() {
  return 'ExerciseEditorState.editing(id: $id, title: $title, description: $description, minutes: $minutes, tags: $tags, attachments: $attachments, availableTags: $availableTags, error: $error, saved: $saved, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$EditingCopyWith<$Res> implements $ExerciseEditorStateCopyWith<$Res> {
  factory _$EditingCopyWith(_Editing value, $Res Function(_Editing) _then) = __$EditingCopyWithImpl;
@override @useResult
$Res call({
 String? id, String title, String description, int minutes, List<String> tags, List<MediaAttachment> attachments, List<TagDef> availableTags, String? error, bool? saved, bool? loading
});




}
/// @nodoc
class __$EditingCopyWithImpl<$Res>
    implements _$EditingCopyWith<$Res> {
  __$EditingCopyWithImpl(this._self, this._then);

  final _Editing _self;
  final $Res Function(_Editing) _then;

/// Create a copy of ExerciseEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? description = null,Object? minutes = null,Object? tags = null,Object? attachments = null,Object? availableTags = null,Object? error = freezed,Object? saved = freezed,Object? loading = freezed,}) {
  return _then(_Editing(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MediaAttachment>,availableTags: null == availableTags ? _self._availableTags : availableTags // ignore: cast_nullable_to_non_nullable
as List<TagDef>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool?,loading: freezed == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
