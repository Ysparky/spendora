// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      type: const TransactionTypeConverter().fromJson(json['type'] as String),
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      description: json['description'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringFrequency: json['recurringFrequency'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'amount': instance.amount,
      'category': instance.category,
      'type': const TransactionTypeConverter().toJson(instance.type),
      'date': const TimestampConverter().toJson(instance.date),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'description': instance.description,
      'isRecurring': instance.isRecurring,
      'recurringFrequency': instance.recurringFrequency,
    };
