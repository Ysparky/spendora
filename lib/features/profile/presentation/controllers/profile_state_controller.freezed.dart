// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileLoadingState {
  bool get isLoading;
  String? get action;

  /// Create a copy of ProfileLoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileLoadingStateCopyWith<ProfileLoadingState> get copyWith =>
      _$ProfileLoadingStateCopyWithImpl<ProfileLoadingState>(
          this as ProfileLoadingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileLoadingState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, action);

  @override
  String toString() {
    return 'ProfileLoadingState(isLoading: $isLoading, action: $action)';
  }
}

/// @nodoc
abstract mixin class $ProfileLoadingStateCopyWith<$Res> {
  factory $ProfileLoadingStateCopyWith(
          ProfileLoadingState value, $Res Function(ProfileLoadingState) _then) =
      _$ProfileLoadingStateCopyWithImpl;
  @useResult
  $Res call({bool isLoading, String? action});
}

/// @nodoc
class _$ProfileLoadingStateCopyWithImpl<$Res>
    implements $ProfileLoadingStateCopyWith<$Res> {
  _$ProfileLoadingStateCopyWithImpl(this._self, this._then);

  final ProfileLoadingState _self;
  final $Res Function(ProfileLoadingState) _then;

  /// Create a copy of ProfileLoadingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? action = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _ProfileLoadingState extends ProfileLoadingState {
  const _ProfileLoadingState({this.isLoading = false, this.action}) : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? action;

  /// Create a copy of ProfileLoadingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileLoadingStateCopyWith<_ProfileLoadingState> get copyWith =>
      __$ProfileLoadingStateCopyWithImpl<_ProfileLoadingState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileLoadingState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, action);

  @override
  String toString() {
    return 'ProfileLoadingState(isLoading: $isLoading, action: $action)';
  }
}

/// @nodoc
abstract mixin class _$ProfileLoadingStateCopyWith<$Res>
    implements $ProfileLoadingStateCopyWith<$Res> {
  factory _$ProfileLoadingStateCopyWith(_ProfileLoadingState value,
          $Res Function(_ProfileLoadingState) _then) =
      __$ProfileLoadingStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLoading, String? action});
}

/// @nodoc
class __$ProfileLoadingStateCopyWithImpl<$Res>
    implements _$ProfileLoadingStateCopyWith<$Res> {
  __$ProfileLoadingStateCopyWithImpl(this._self, this._then);

  final _ProfileLoadingState _self;
  final $Res Function(_ProfileLoadingState) _then;

  /// Create a copy of ProfileLoadingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? action = freezed,
  }) {
    return _then(_ProfileLoadingState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
