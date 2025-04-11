import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required DateTime createdAt,
    String? name,
    String? photoUrl,
    String? currency,
    bool? darkMode,
    bool? notificationsEnabled,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(User user) => UserModel(
        id: user.uid,
        email: user.email!,
        name: user.displayName,
        photoUrl: user.photoURL,
        currency: 'USD', // Default
        darkMode: false, // Default
        notificationsEnabled: true, // Default
        createdAt: DateTime.now(),
      );

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data was null');

    // Convert Timestamp to DateTime
    final json = Map<String, dynamic>.from(data);
    if (data['createdAt'] is Timestamp) {
      json['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    return UserModel.fromJson(json);
  }
}

extension UserModelX on UserModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    // Convert DateTime to Timestamp for Firestore
    json['createdAt'] = Timestamp.fromDate(createdAt);
    return json;
  }
}
