import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_state_controller.freezed.dart';
part 'profile_state_controller.g.dart';

/// Represents the loading state for profile operations
@freezed
abstract class ProfileLoadingState with _$ProfileLoadingState {
  const factory ProfileLoadingState({
    @Default(false) bool isLoading,
    String? action,
  }) = _ProfileLoadingState;

  const ProfileLoadingState._();

  /// Creates a new state with loading cleared
  ProfileLoadingState clearLoading() =>
      copyWith(isLoading: false, action: null);

  /// Creates a new state for a specific loading action
  ProfileLoadingState setLoading(String action) =>
      copyWith(isLoading: true, action: action);
}

/// Profile state notifier provider
@Riverpod(keepAlive: true)
class ProfileState extends _$ProfileState {
  @override
  ProfileLoadingState build() {
    return const ProfileLoadingState();
  }

  /// Start loading for a specific action
  void startLoading(String action) {
    state = state.setLoading(action);
  }

  /// Stop all loading
  void stopLoading() {
    state = state.clearLoading();
  }
}
