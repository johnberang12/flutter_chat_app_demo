import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/storage/storage_service.dart';
import '../../../utils/compute_md5__hash.dart';
part 'image_upload_repository.g.dart';

enum FileExtension {
  jpeg(contentType: 'image/jpeg'),
  jpg(contentType: 'image/jpeg'),
  png(contentType: 'image/png'),
  pdf(contentType: 'application/pdf');

  const FileExtension({required this.contentType});
  final String contentType;
}

//* unit test done
class ImageUploadRepository implements StorageService {
  ImageUploadRepository({required this.storage});
  final FirebaseStorage storage;

  Future<String?> _uploadSingleFile(
      File? file, String path, SettableMetadata metadata) async {
    // throw Exception('upload failed');
    if (file == null) return null;

    final storageRef = storage.ref().child(path);
    final uploadTask = storageRef.putFile(file, metadata);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  @override
  Future<List<String>> uploadFileImages(
      {required List<File?> files, required String path}) async {
    final urls = <String>[];

    if (files.isEmpty) return urls;

    for (var file in files) {
      if (file != null) {
        final ext = _getExtension(file);
        final md5Hash = computeMD5Hash(file);
        final imagePath = '$path/$md5Hash.${ext.name}';

        final url = await _uploadSingleFile(
            file, imagePath, SettableMetadata(contentType: ext.contentType));
        if (url != null) {
          urls.add(url);
        }
      }
    }

    return urls;
  }

  FileExtension _getExtension(File file) {
    final ext = file.path.split('.').last; //example-image.jpeg
    for (var value in FileExtension.values) {
      if (value.name == ext) return value;
    }
    return FileExtension.jpeg;
  }

  @override
  Future<void> deleteImages(List<String> imageUrls) async {
    if (imageUrls.isNotEmpty) {
      for (var url in imageUrls) {
        await storage.refFromURL(url).delete();
      }
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) =>
    FirebaseStorage.instance;

@Riverpod(keepAlive: true)
ImageUploadRepository imageUploadRepository(ImageUploadRepositoryRef ref) =>
    ImageUploadRepository(storage: ref.watch(firebaseStorageProvider));
