import 'dart:io';

/// Abstract class `StorageService`
///
/// This class serves as a contract for any storage services used in this application.
/// It includes the necessary methods for uploading and deleting image files.
///
/// Why this exists:
/// - Encourages consistency across different implementations.
/// - Facilitates easy mocking and testing.
///
abstract class StorageService {
  Future<List<String>> uploadFileImages({
    required List<File?> files,
    required String path,
  });

  Future<void> deleteImages(List<String> imageUrls);
}
