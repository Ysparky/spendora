// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      currency: json['currency'] as String?,
      darkMode: json['darkMode'] as bool?,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'currency': instance.currency,
      'darkMode': instance.darkMode,
      'notificationsEnabled': instance.notificationsEnabled,
    };
