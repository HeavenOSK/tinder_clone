// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'swipe_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$SwipeSessionStateTearOff {
  const _$SwipeSessionStateTearOff();

// ignore: unused_element
  _SwipeSessionState call(
      {@nullable Offset startPosition,
      @nullable Offset currentPosition,
      @nullable Offset localPosition}) {
    return _SwipeSessionState(
      startPosition: startPosition,
      currentPosition: currentPosition,
      localPosition: localPosition,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $SwipeSessionState = _$SwipeSessionStateTearOff();

/// @nodoc
mixin _$SwipeSessionState {
  @nullable
  Offset get startPosition;
  @nullable
  Offset get currentPosition;
  @nullable
  Offset get localPosition;

  $SwipeSessionStateCopyWith<SwipeSessionState> get copyWith;
}

/// @nodoc
abstract class $SwipeSessionStateCopyWith<$Res> {
  factory $SwipeSessionStateCopyWith(
          SwipeSessionState value, $Res Function(SwipeSessionState) then) =
      _$SwipeSessionStateCopyWithImpl<$Res>;
  $Res call(
      {@nullable Offset startPosition,
      @nullable Offset currentPosition,
      @nullable Offset localPosition});
}

/// @nodoc
class _$SwipeSessionStateCopyWithImpl<$Res>
    implements $SwipeSessionStateCopyWith<$Res> {
  _$SwipeSessionStateCopyWithImpl(this._value, this._then);

  final SwipeSessionState _value;
  // ignore: unused_field
  final $Res Function(SwipeSessionState) _then;

  @override
  $Res call({
    Object startPosition = freezed,
    Object currentPosition = freezed,
    Object localPosition = freezed,
  }) {
    return _then(_value.copyWith(
      startPosition: startPosition == freezed
          ? _value.startPosition
          : startPosition as Offset,
      currentPosition: currentPosition == freezed
          ? _value.currentPosition
          : currentPosition as Offset,
      localPosition: localPosition == freezed
          ? _value.localPosition
          : localPosition as Offset,
    ));
  }
}

/// @nodoc
abstract class _$SwipeSessionStateCopyWith<$Res>
    implements $SwipeSessionStateCopyWith<$Res> {
  factory _$SwipeSessionStateCopyWith(
          _SwipeSessionState value, $Res Function(_SwipeSessionState) then) =
      __$SwipeSessionStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable Offset startPosition,
      @nullable Offset currentPosition,
      @nullable Offset localPosition});
}

/// @nodoc
class __$SwipeSessionStateCopyWithImpl<$Res>
    extends _$SwipeSessionStateCopyWithImpl<$Res>
    implements _$SwipeSessionStateCopyWith<$Res> {
  __$SwipeSessionStateCopyWithImpl(
      _SwipeSessionState _value, $Res Function(_SwipeSessionState) _then)
      : super(_value, (v) => _then(v as _SwipeSessionState));

  @override
  _SwipeSessionState get _value => super._value as _SwipeSessionState;

  @override
  $Res call({
    Object startPosition = freezed,
    Object currentPosition = freezed,
    Object localPosition = freezed,
  }) {
    return _then(_SwipeSessionState(
      startPosition: startPosition == freezed
          ? _value.startPosition
          : startPosition as Offset,
      currentPosition: currentPosition == freezed
          ? _value.currentPosition
          : currentPosition as Offset,
      localPosition: localPosition == freezed
          ? _value.localPosition
          : localPosition as Offset,
    ));
  }
}

/// @nodoc
class _$_SwipeSessionState implements _SwipeSessionState {
  const _$_SwipeSessionState(
      {@nullable this.startPosition,
      @nullable this.currentPosition,
      @nullable this.localPosition});

  @override
  @nullable
  final Offset startPosition;
  @override
  @nullable
  final Offset currentPosition;
  @override
  @nullable
  final Offset localPosition;

  @override
  String toString() {
    return 'SwipeSessionState(startPosition: $startPosition, currentPosition: $currentPosition, localPosition: $localPosition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SwipeSessionState &&
            (identical(other.startPosition, startPosition) ||
                const DeepCollectionEquality()
                    .equals(other.startPosition, startPosition)) &&
            (identical(other.currentPosition, currentPosition) ||
                const DeepCollectionEquality()
                    .equals(other.currentPosition, currentPosition)) &&
            (identical(other.localPosition, localPosition) ||
                const DeepCollectionEquality()
                    .equals(other.localPosition, localPosition)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(startPosition) ^
      const DeepCollectionEquality().hash(currentPosition) ^
      const DeepCollectionEquality().hash(localPosition);

  @override
  _$SwipeSessionStateCopyWith<_SwipeSessionState> get copyWith =>
      __$SwipeSessionStateCopyWithImpl<_SwipeSessionState>(this, _$identity);
}

abstract class _SwipeSessionState implements SwipeSessionState {
  const factory _SwipeSessionState(
      {@nullable Offset startPosition,
      @nullable Offset currentPosition,
      @nullable Offset localPosition}) = _$_SwipeSessionState;

  @override
  @nullable
  Offset get startPosition;
  @override
  @nullable
  Offset get currentPosition;
  @override
  @nullable
  Offset get localPosition;
  @override
  _$SwipeSessionStateCopyWith<_SwipeSessionState> get copyWith;
}
