import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/auth/data/repositories/auth_repository.dart';
import 'package:spendora/features/auth/data/repositories/user_repository.dart';
import 'package:spendora/features/auth/domain/models/user_model.dart';
import 'package:spendora/features/auth/domain/utils/firebase_auth_error_handler.dart';
import 'package:spendora/features/auth/domain/validators/auth_validator.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Stream<User?> build() {
    return ref.watch(authRepositoryProvider).authStateChanges;
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      state = const AsyncLoading();
      AuthValidator.validateEmail(email);
      AuthValidator.validatePassword(password);

      final credential = await ref.read(authRepositoryProvider).signInWithEmail(
            email.trim(),
            password,
          );
      state = AsyncData(credential.user);
    } on AuthValidationError catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } on FirebaseAuthException catch (e, stack) {
      state = AsyncError(FirebaseAuthErrorHandler.handleError(e), stack);
    } on Exception catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }

  Future<void> registerWithEmail(
    String email,
    String password, {
    required String name,
    required String confirmPassword,
  }) async {
    try {
      state = const AsyncLoading();
      AuthValidator.validateName(name);
      AuthValidator.validateEmail(email);
      AuthValidator.validatePassword(password);
      AuthValidator.validatePasswordMatch(password, confirmPassword);

      // 1. Create the user in Firebase Auth
      final credential =
          await ref.read(authRepositoryProvider).registerWithEmail(
                email.trim(),
                password,
              );

      // 2. Update the user's display name and wait for it to complete
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);

        // 3. Reload the user to make sure the display name is updated in the
        // current user object
        await credential.user!.reload();

        // 4. Save user data in Firestore
        final userModel =
            UserModel.fromFirebaseUser(FirebaseAuth.instance.currentUser!);
        await ref.read(userRepositoryProvider).createUser(userModel);
      }

      state = AsyncData(FirebaseAuth.instance.currentUser);
    } on AuthValidationError catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } on FirebaseAuthException catch (e, stack) {
      state = AsyncError(FirebaseAuthErrorHandler.handleError(e), stack);
    } on Exception catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AsyncLoading();
      final credential =
          await ref.read(authRepositoryProvider).signInWithGoogle();

      // Save user profile in Firestore if it's a new user
      final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser && credential.user != null) {
        final userModel = UserModel.fromFirebaseUser(credential.user!);
        await ref.read(userRepositoryProvider).createUser(userModel);
      }

      state = AsyncData(credential.user);
    } on FirebaseAuthException catch (e, stack) {
      state = AsyncError(FirebaseAuthErrorHandler.handleError(e), stack);
    } on Exception catch (e, stack) {
      state = AsyncError(
          FirebaseAuthErrorHandler.handleGoogleSignInError(e), stack);
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AuthValidator.validateEmail(email);
      await ref
          .read(authRepositoryProvider)
          .sendPasswordResetEmail(email.trim());
    } on AuthValidationError catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } on FirebaseAuthException catch (e, stack) {
      state = AsyncError(FirebaseAuthErrorHandler.handleError(e), stack);
    } on Exception catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }
}
