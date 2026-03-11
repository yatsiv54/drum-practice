// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlanEditorState {

 String? get id; String get title; List<String> get exerciseIds;// порядок = порядок у плані
 bool get saving; bool get saved; String? get error;
/// Create a copy of PlanEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanEditorStateCopyWith<PlanEditorState> get copyWith => _$PlanEditorStateCopyWithImpl<PlanEditorState>(this as PlanEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanEditorState&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.exerciseIds, exerciseIds)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(exerciseIds),saving,saved,error);

@override
String toString() {
  return 'PlanEditorState(id: $id, title: $title, exerciseIds: $exerciseIds, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class $PlanEditorStateCopyWith<$Res>  {
  factory $PlanEditorStateCopyWith(PlanEditorState value, $Res Function(PlanEditorState) _then) = _$PlanEditorStateCopyWithImpl;
@useResult
$Res call({
 String? id, String title, List<String> exerciseIds, bool saving, bool saved, String? error
});




}
/// @nodoc
class _$PlanEditorStateCopyWithImpl<$Res>
    implements $PlanEditorStateCopyWith<$Res> {
  _$PlanEditorStateCopyWithImpl(this._self, this._then);

  final PlanEditorState _self;
  final $Res Function(PlanEditorState) _then;

/// Create a copy of PlanEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? exerciseIds = null,Object? saving = null,Object? saved = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,exerciseIds: null == exerciseIds ? _self.exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanEditorState].
extension PlanEditorStatePatterns on PlanEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanEditorState value)  $default,){
final _that = this;
switch (_that) {
case _PlanEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _PlanEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String title,  List<String> exerciseIds,  bool saving,  bool saved,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanEditorState() when $default != null:
return $default(_that.id,_that.title,_that.exerciseIds,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String title,  List<String> exerciseIds,  bool saving,  bool saved,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PlanEditorState():
return $default(_that.id,_that.title,_that.exerciseIds,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String title,  List<String> exerciseIds,  bool saving,  bool saved,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PlanEditorState() when $default != null:
return $default(_that.id,_that.title,_that.exerciseIds,_that.saving,_that.saved,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PlanEditorState implements PlanEditorState {
  const _PlanEditorState({this.id, this.title = '', final  List<String> exerciseIds = const [], this.saving = false, this.saved = false, this.error}): _exerciseIds = exerciseIds;
  

@override final  String? id;
@override@JsonKey() final  String title;
 final  List<String> _exerciseIds;
@override@JsonKey() List<String> get exerciseIds {
  if (_exerciseIds is EqualUnmodifiableListView) return _exerciseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exerciseIds);
}

// порядок = порядок у плані
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override final  String? error;

/// Create a copy of PlanEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanEditorStateCopyWith<_PlanEditorState> get copyWith => __$PlanEditorStateCopyWithImpl<_PlanEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanEditorState&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._exerciseIds, _exerciseIds)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_exerciseIds),saving,saved,error);

@override
String toString() {
  return 'PlanEditorState(id: $id, title: $title, exerciseIds: $exerciseIds, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PlanEditorStateCopyWith<$Res> implements $PlanEditorStateCopyWith<$Res> {
  factory _$PlanEditorStateCopyWith(_PlanEditorState value, $Res Function(_PlanEditorState) _then) = __$PlanEditorStateCopyWithImpl;
@override @useResult
$Res call({
 String? id, String title, List<String> exerciseIds, bool saving, bool saved, String? error
});




}
/// @nodoc
class __$PlanEditorStateCopyWithImpl<$Res>
    implements _$PlanEditorStateCopyWith<$Res> {
  __$PlanEditorStateCopyWithImpl(this._self, this._then);

  final _PlanEditorState _self;
  final $Res Function(_PlanEditorState) _then;

/// Create a copy of PlanEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? exerciseIds = null,Object? saving = null,Object? saved = null,Object? error = freezed,}) {
  return _then(_PlanEditorState(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,exerciseIds: null == exerciseIds ? _self._exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
