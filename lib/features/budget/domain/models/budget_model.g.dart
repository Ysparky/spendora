// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => _BudgetModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      period: $enumDecode(_$BudgetPeriodEnumMap, json['period']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? false,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BudgetModelToJson(_BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'category': instance.category,
      'amount': instance.amount,
      'period': _$BudgetPeriodEnumMap[instance.period]!,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'spent': instance.spent,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BudgetPeriodEnumMap = {
  BudgetPeriod.daily: 'daily',
  BudgetPeriod.weekly: 'weekly',
  BudgetPeriod.monthly: 'monthly',
  BudgetPeriod.yearly: 'yearly',
};
