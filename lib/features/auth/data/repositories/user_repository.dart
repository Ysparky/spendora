import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/auth/domain/models/user_model.dart';

part 'user_repository.g.dart';

abstract class IUserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(UserModel user);
}

class FirebaseUserRepository implements IUserRepository {
  FirebaseUserRepository(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<void> createUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).set(user.toFirestore());
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();

    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).update(user.toFirestore());
  }
}

@Riverpod(keepAlive: true)
IUserRepository userRepository(Ref ref) {
  return FirebaseUserRepository(FirebaseFirestore.instance);
}
