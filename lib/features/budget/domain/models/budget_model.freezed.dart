// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetModel {
  String get id;
  String get userId;
  String get category;
  double get amount;
  BudgetPeriod get period;
  DateTime? get startDate;
  DateTime? get endDate;
  bool get isActive;
  double get spent;
  String? get notes;
  DateTime get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetModelCopyWith<BudgetModel> get copyWith =>
      _$BudgetModelCopyWithImpl<BudgetModel>(this as BudgetModel, _$identity);

  /// Serializes this BudgetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, category, amount,
      period, startDate, endDate, isActive, spent, notes, createdAt, updatedAt);

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, category: $category, amount: $amount, period: $period, startDate: $startDate, endDate: $endDate, isActive: $isActive, spent: $spent, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetModelCopyWith<$Res> {
  factory $BudgetModelCopyWith(
          BudgetModel value, $Res Function(BudgetModel) _then) =
      _$BudgetModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String category,
      double amount,
      BudgetPeriod period,
      DateTime? startDate,
      DateTime? endDate,
      bool isActive,
      double spent,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BudgetModelCopyWithImpl<$Res> implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._self, this._then);

  final BudgetModel _self;
  final $Res Function(BudgetModel) _then;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? category = null,
    Object? amount = null,
    Object? period = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? spent = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      spent: null == spent
          ? _self.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BudgetModel extends BudgetModel {
  const _BudgetModel(
      {required this.id,
      required this.userId,
      required this.category,
      required this.amount,
      required this.period,
      this.startDate,
      this.endDate,
      this.isActive = false,
      this.spent = 0.0,
      this.notes,
      required this.createdAt,
      this.updatedAt})
      : super._();
  factory _BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String category;
  @override
  final double amount;
  @override
  final BudgetPeriod period;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final double spent;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetModelCopyWith<_BudgetModel> get copyWith =>
      __$BudgetModelCopyWithImpl<_BudgetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, category, amount,
      period, startDate, endDate, isActive, spent, notes, createdAt, updatedAt);

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, category: $category, amount: $amount, period: $period, startDate: $startDate, endDate: $endDate, isActive: $isActive, spent: $spent, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetModelCopyWith<$Res>
    implements $BudgetModelCopyWith<$Res> {
  factory _$BudgetModelCopyWith(
          _BudgetModel value, $Res Function(_BudgetModel) _then) =
      __$BudgetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String category,
      double amount,
      BudgetPeriod period,
      DateTime? startDate,
      DateTime? endDate,
      bool isActive,
      double spent,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$BudgetModelCopyWithImpl<$Res> implements _$BudgetModelCopyWith<$Res> {
  __$BudgetModelCopyWithImpl(this._self, this._then);

  final _BudgetModel _self;
  final $Res Function(_BudgetModel) _then;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? category = null,
    Object? amount = null,
    Object? period = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? spent = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_BudgetModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      spent: null == spent
          ? _self.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
