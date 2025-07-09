// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

 GamePhase get phase; List<Player> get players; int get leaderIndex; int get revealIndex;// 新增
 int get goodScore; int get evilScore; int get failedVoteStreak;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.leaderIndex, leaderIndex) || other.leaderIndex == leaderIndex)&&(identical(other.revealIndex, revealIndex) || other.revealIndex == revealIndex)&&(identical(other.goodScore, goodScore) || other.goodScore == goodScore)&&(identical(other.evilScore, evilScore) || other.evilScore == evilScore)&&(identical(other.failedVoteStreak, failedVoteStreak) || other.failedVoteStreak == failedVoteStreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(players),leaderIndex,revealIndex,goodScore,evilScore,failedVoteStreak);

@override
String toString() {
  return 'GameState(phase: $phase, players: $players, leaderIndex: $leaderIndex, revealIndex: $revealIndex, goodScore: $goodScore, evilScore: $evilScore, failedVoteStreak: $failedVoteStreak)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 GamePhase phase, List<Player> players, int leaderIndex, int revealIndex, int goodScore, int evilScore, int failedVoteStreak
});




}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? players = null,Object? leaderIndex = null,Object? revealIndex = null,Object? goodScore = null,Object? evilScore = null,Object? failedVoteStreak = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,leaderIndex: null == leaderIndex ? _self.leaderIndex : leaderIndex // ignore: cast_nullable_to_non_nullable
as int,revealIndex: null == revealIndex ? _self.revealIndex : revealIndex // ignore: cast_nullable_to_non_nullable
as int,goodScore: null == goodScore ? _self.goodScore : goodScore // ignore: cast_nullable_to_non_nullable
as int,evilScore: null == evilScore ? _self.evilScore : evilScore // ignore: cast_nullable_to_non_nullable
as int,failedVoteStreak: null == failedVoteStreak ? _self.failedVoteStreak : failedVoteStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GamePhase phase,  List<Player> players,  int leaderIndex,  int revealIndex,  int goodScore,  int evilScore,  int failedVoteStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.players,_that.leaderIndex,_that.revealIndex,_that.goodScore,_that.evilScore,_that.failedVoteStreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GamePhase phase,  List<Player> players,  int leaderIndex,  int revealIndex,  int goodScore,  int evilScore,  int failedVoteStreak)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.phase,_that.players,_that.leaderIndex,_that.revealIndex,_that.goodScore,_that.evilScore,_that.failedVoteStreak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GamePhase phase,  List<Player> players,  int leaderIndex,  int revealIndex,  int goodScore,  int evilScore,  int failedVoteStreak)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.players,_that.leaderIndex,_that.revealIndex,_that.goodScore,_that.evilScore,_that.failedVoteStreak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState implements GameState {
  const _GameState({this.phase = GamePhase.setup, final  List<Player> players = const <Player>[], this.leaderIndex = 0, this.revealIndex = 0, this.goodScore = 0, this.evilScore = 0, this.failedVoteStreak = 0}): _players = players;
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override@JsonKey() final  GamePhase phase;
 final  List<Player> _players;
@override@JsonKey() List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override@JsonKey() final  int leaderIndex;
@override@JsonKey() final  int revealIndex;
// 新增
@override@JsonKey() final  int goodScore;
@override@JsonKey() final  int evilScore;
@override@JsonKey() final  int failedVoteStreak;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.leaderIndex, leaderIndex) || other.leaderIndex == leaderIndex)&&(identical(other.revealIndex, revealIndex) || other.revealIndex == revealIndex)&&(identical(other.goodScore, goodScore) || other.goodScore == goodScore)&&(identical(other.evilScore, evilScore) || other.evilScore == evilScore)&&(identical(other.failedVoteStreak, failedVoteStreak) || other.failedVoteStreak == failedVoteStreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(_players),leaderIndex,revealIndex,goodScore,evilScore,failedVoteStreak);

@override
String toString() {
  return 'GameState(phase: $phase, players: $players, leaderIndex: $leaderIndex, revealIndex: $revealIndex, goodScore: $goodScore, evilScore: $evilScore, failedVoteStreak: $failedVoteStreak)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 GamePhase phase, List<Player> players, int leaderIndex, int revealIndex, int goodScore, int evilScore, int failedVoteStreak
});




}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? players = null,Object? leaderIndex = null,Object? revealIndex = null,Object? goodScore = null,Object? evilScore = null,Object? failedVoteStreak = null,}) {
  return _then(_GameState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,leaderIndex: null == leaderIndex ? _self.leaderIndex : leaderIndex // ignore: cast_nullable_to_non_nullable
as int,revealIndex: null == revealIndex ? _self.revealIndex : revealIndex // ignore: cast_nullable_to_non_nullable
as int,goodScore: null == goodScore ? _self.goodScore : goodScore // ignore: cast_nullable_to_non_nullable
as int,evilScore: null == evilScore ? _self.evilScore : evilScore // ignore: cast_nullable_to_non_nullable
as int,failedVoteStreak: null == failedVoteStreak ? _self.failedVoteStreak : failedVoteStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
