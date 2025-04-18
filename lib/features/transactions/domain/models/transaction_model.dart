import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Enum representing transaction types
enum TransactionType {
  expense,
  income,
}

/// Converter to handle TransactionType enum in Firestore
class TransactionTypeConverter
    implements JsonConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromJson(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionType.expense,
    );
  }

  @override
  String toJson(TransactionType type) => type.name;
}

/// Converter to handle Timestamp in Firestore
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Model representing a financial transaction
@freezed
abstract class TransactionModel with _$TransactionModel {
  /// Main constructor for creating a transaction
  const factory TransactionModel({
    required String id,
    required String userId,
    required String title,
    required double amount,
    required String category,
    @TransactionTypeConverter() required TransactionType type,
    @TimestampConverter() required DateTime date,
    @TimestampConverter() required DateTime createdAt,
    String? description,
    @Default(false) bool isRecurring,
    String? recurringFrequency, // daily, weekly, monthly, yearly
  }) = _TransactionModel;
  const TransactionModel._();

  /// Factory constructor to create a transaction from Firestore document
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Factory to create a new transaction with default values
  factory TransactionModel.create({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required TransactionType type,
    String? description,
    DateTime? date,
    bool isRecurring = false,
    String? recurringFrequency,
  }) {
    final now = DateTime.now();
    return TransactionModel(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      amount: amount,
      description: description,
      category: category,
      type: type,
      date: date ?? now,
      createdAt: now,
      isRecurring: isRecurring,
      recurringFrequency: recurringFrequency,
    );
  }

  /// Get the sign of the transaction amount based on type
  double get signedAmount => type == TransactionType.expense ? -amount : amount;
}
