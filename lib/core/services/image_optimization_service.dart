import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// A service for optimizing images before uploading to Firebase Storage
///
/// This service helps reduce storage usage, bandwidth consumption, and
/// improves image loading performance by optimizing images before uploading.
class ImageOptimizationService {
  /// Optimizes a profile image for upload
  ///
  /// Resizes the image to appropriate dimensions for profile pictures and
  /// applies quality optimization. Returns a new File with the optimized image.
  static Future<File> optimizeProfileImage(File imageFile) async {
    try {
      // Read image bytes
      final bytes = await imageFile.readAsBytes();
      // Decode image
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to 512x512 for profile pictures
      // We use square dimensions to avoid distortion in CircleAvatar
      final resized = img.copyResize(
        image,
        width: 512,
        height: 512,
        interpolation: img.Interpolation.cubic,
      );

      // Encode as WebP for better compression while maintaining quality
      final optimizedBytes = img.encodeJpg(resized, quality: 90);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final optimizedFile = File('${tempDir.path}/optimized_profile_image.jpg');
      await optimizedFile.writeAsBytes(optimizedBytes);

      return optimizedFile;
    } on IOException catch (e) {
      debugPrint('IO error optimizing image: $e');
      return imageFile;
    } on Exception catch (e) {
      debugPrint('Error optimizing image: $e');
      return imageFile;
    }
  }

  /// Creates metadata for Firebase Storage with caching directives
  static SettableMetadata getProfileImageMetadata() {
    return SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'purpose': 'profile',
        'width': '512',
        'height': '512',
      },
      // Add cache control headers for better performance
      cacheControl: 'public, max-age=86400', // Cache for 24 hours
    );
  }
}
