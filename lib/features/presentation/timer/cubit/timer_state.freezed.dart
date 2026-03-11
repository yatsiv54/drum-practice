// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimerState()';
}


}

/// @nodoc
class $TimerStateCopyWith<$Res>  {
$TimerStateCopyWith(TimerState _, $Res Function(TimerState) __);
}


/// Adds pattern-matching-related methods to [TimerState].
extension TimerStatePatterns on TimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Idle value)?  idle,TResult Function( _Running value)?  running,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Idle() when idle != null:
return idle(_that);case _Running() when running != null:
return running(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Idle value)  idle,required TResult Function( _Running value)  running,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Idle():
return idle(_that);case _Running():
return running(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Idle value)?  idle,TResult? Function( _Running value)?  running,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Idle() when idle != null:
return idle(_that);case _Running() when running != null:
return running(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<TimerPlanItem> items)?  idle,TResult Function( Plan plan,  int index,  int secsLeft,  int secsTotal,  bool paused)?  running,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Idle() when idle != null:
return idle(_that.items);case _Running() when running != null:
return running(_that.plan,_that.index,_that.secsLeft,_that.secsTotal,_that.paused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<TimerPlanItem> items)  idle,required TResult Function( Plan plan,  int index,  int secsLeft,  int secsTotal,  bool paused)  running,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Idle():
return idle(_that.items);case _Running():
return running(_that.plan,_that.index,_that.secsLeft,_that.secsTotal,_that.paused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<TimerPlanItem> items)?  idle,TResult? Function( Plan plan,  int index,  int secsLeft,  int secsTotal,  bool paused)?  running,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Idle() when idle != null:
return idle(_that.items);case _Running() when running != null:
return running(_that.plan,_that.index,_that.secsLeft,_that.secsTotal,_that.paused);case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements TimerState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimerState.loading()';
}


}




/// @nodoc


class _Idle implements TimerState {
  const _Idle({required final  List<TimerPlanItem> items}): _items = items;
  

 final  List<TimerPlanItem> _items;
 List<TimerPlanItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdleCopyWith<_Idle> get copyWith => __$IdleCopyWithImpl<_Idle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TimerState.idle(items: $items)';
}


}

/// @nodoc
abstract mixin class _$IdleCopyWith<$Res> implements $TimerStateCopyWith<$Res> {
  factory _$IdleCopyWith(_Idle value, $Res Function(_Idle) _then) = __$IdleCopyWithImpl;
@useResult
$Res call({
 List<TimerPlanItem> items
});




}
/// @nodoc
class __$IdleCopyWithImpl<$Res>
    implements _$IdleCopyWith<$Res> {
  __$IdleCopyWithImpl(this._self, this._then);

  final _Idle _self;
  final $Res Function(_Idle) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Idle(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TimerPlanItem>,
  ));
}


}

/// @nodoc


class _Running implements TimerState {
  const _Running({required this.plan, required this.index, required this.secsLeft, required this.secsTotal, required this.paused});
  

 final  Plan plan;
 final  int index;
 final  int secsLeft;
 final  int secsTotal;
 final  bool paused;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunningCopyWith<_Running> get copyWith => __$RunningCopyWithImpl<_Running>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Running&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.index, index) || other.index == index)&&(identical(other.secsLeft, secsLeft) || other.secsLeft == secsLeft)&&(identical(other.secsTotal, secsTotal) || other.secsTotal == secsTotal)&&(identical(other.paused, paused) || other.paused == paused));
}


@override
int get hashCode => Object.hash(runtimeType,plan,index,secsLeft,secsTotal,paused);

@override
String toString() {
  return 'TimerState.running(plan: $plan, index: $index, secsLeft: $secsLeft, secsTotal: $secsTotal, paused: $paused)';
}


}

/// @nodoc
abstract mixin class _$RunningCopyWith<$Res> implements $TimerStateCopyWith<$Res> {
  factory _$RunningCopyWith(_Running value, $Res Function(_Running) _then) = __$RunningCopyWithImpl;
@useResult
$Res call({
 Plan plan, int index, int secsLeft, int secsTotal, bool paused
});


$PlanCopyWith<$Res> get plan;

}
/// @nodoc
class __$RunningCopyWithImpl<$Res>
    implements _$RunningCopyWith<$Res> {
  __$RunningCopyWithImpl(this._self, this._then);

  final _Running _self;
  final $Res Function(_Running) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? index = null,Object? secsLeft = null,Object? secsTotal = null,Object? paused = null,}) {
  return _then(_Running(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Plan,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,secsLeft: null == secsLeft ? _self.secsLeft : secsLeft // ignore: cast_nullable_to_non_nullable
as int,secsTotal: null == secsTotal ? _self.secsTotal : secsTotal // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanCopyWith<$Res> get plan {
  
  return $PlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

// dart format on
