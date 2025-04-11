import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether any profile operation is currently loading
final profileLoadingProvider = StateProvider<bool>((ref) => false);

/// Tracks which specific profile action is currently loading (if any)
final loadingActionProvider = StateProvider<String?>((ref) => null);
