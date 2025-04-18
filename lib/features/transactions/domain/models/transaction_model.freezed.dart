// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {
  String get id;
  String get userId;
  String get title;
  double get amount;
  String get category;
  @TransactionTypeConverter()
  TransactionType get type;
  @TimestampConverter()
  DateTime get date;
  @TimestampConverter()
  DateTime get createdAt;
  String? get description;
  bool get isRecurring;
  String? get recurringFrequency;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      _$TransactionModelCopyWithImpl<TransactionModel>(
          this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringFrequency, recurringFrequency) ||
                other.recurringFrequency == recurringFrequency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      amount,
      category,
      type,
      date,
      createdAt,
      description,
      isRecurring,
      recurringFrequency);

  @override
  String toString() {
    return 'TransactionModel(id: $id, userId: $userId, title: $title, amount: $amount, category: $category, type: $type, date: $date, createdAt: $createdAt, description: $description, isRecurring: $isRecurring, recurringFrequency: $recurringFrequency)';
  }
}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) _then) =
      _$TransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      double amount,
      String category,
      @TransactionTypeConverter() TransactionType type,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime createdAt,
      String? description,
      bool isRecurring,
      String? recurringFrequency});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? amount = null,
    Object? category = null,
    Object? type = null,
    Object? date = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? isRecurring = null,
    Object? recurringFrequency = freezed,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: null == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringFrequency: freezed == recurringFrequency
          ? _self.recurringFrequency
          : recurringFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionModel extends TransactionModel {
  const _TransactionModel(
      {required this.id,
      required this.userId,
      required this.title,
      required this.amount,
      required this.category,
      @TransactionTypeConverter() required this.type,
      @TimestampConverter() required this.date,
      @TimestampConverter() required this.createdAt,
      this.description,
      this.isRecurring = false,
      this.recurringFrequency})
      : super._();
  factory _TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final double amount;
  @override
  final String category;
  @override
  @TransactionTypeConverter()
  final TransactionType type;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isRecurring;
  @override
  final String? recurringFrequency;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionModelCopyWith<_TransactionModel> get copyWith =>
      __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringFrequency, recurringFrequency) ||
                other.recurringFrequency == recurringFrequency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      amount,
      category,
      type,
      date,
      createdAt,
      description,
      isRecurring,
      recurringFrequency);

  @override
  String toString() {
    return 'TransactionModel(id: $id, userId: $userId, title: $title, amount: $amount, category: $category, type: $type, date: $date, createdAt: $createdAt, description: $description, isRecurring: $isRecurring, recurringFrequency: $recurringFrequency)';
  }
}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(
          _TransactionModel value, $Res Function(_TransactionModel) _then) =
      __$TransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      double amount,
      String category,
      @TransactionTypeConverter() TransactionType type,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime createdAt,
      String? description,
      bool isRecurring,
      String? recurringFrequency});
}

/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? amount = null,
    Object? category = null,
    Object? type = null,
    Object? date = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? isRecurring = null,
    Object? recurringFrequency = freezed,
  }) {
    return _then(_TransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: null == isRecurring
          ? _self.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringFrequency: freezed == recurringFrequency
          ? _self.recurringFrequency
          : recurringFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
